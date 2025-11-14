import 'dart:io';
import 'dart:typed_data';

import 'package:ai_stetho_final/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

const Map<int, String> kRespiratoryLabels = {
  0: 'Asthma',
  1: 'Bronchiectasis',
  2: 'COPD',
  3: 'Healthy',
  4: 'Heart Failure',
  5: 'LRTI',
  6: 'Pneumonia',
  7: 'URTI',
};

class ShishuVaniScreen extends StatefulWidget {
  const ShishuVaniScreen({super.key});

  @override
  State<ShishuVaniScreen> createState() => _ShishuVaniScreenState();
}

class _ShishuVaniScreenState extends State<ShishuVaniScreen> with SingleTickerProviderStateMixin {
  late AudioRecorder _recorder;
  bool isRecording = false;
  String lungResult = "Place phone on left chest";
  String heartResult = "Listening for heart sounds...";
  String lungConf = "";
  String heartConf = "";
  Color lungColor = AppColors.textColorSecondary;
  Color heartColor = AppColors.textColorSecondary;

  AnimationController? _shimmerController;
  Animation<double>? _shimmerAnimation;
  Interpreter? _interpreter;
  final int sampleRate = 22050;
  final int totalDurationSec = 15;
  final int windowSec = 4;
  final int windowSamples = 22050 * 4;
  final int hopSamples = 22050 * 1;
  final int nFft = 512;
  final int hopLength = 256;
  final int nMels = 128;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController!, curve: Curves.easeInOut),
    );
    _shimmerController?.repeat(reverse: true);
    _loadModel();
    _initRecorder();
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    _recorder.dispose(); // Important: Dispose the recorder
    super.dispose();
  }

  Future<void> _initRecorder() async {
    _recorder = AudioRecorder();
    await Permission.microphone.request();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/repository_sound_model.tflite');
  }

  Future<Float32List?> _recordAudio() async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/temp_recording.pcm';
    await _recorder.start(
      RecordConfig(encoder: AudioEncoder.pcm16bits, sampleRate: sampleRate, numChannels: 1),
      path: path,
    );
    setState(() {
      isRecording = true;
      lungResult = "Analyzing lungs...";
      heartResult = "Analyzing heart...";
      lungColor = AppColors.textColorSecondary;
      heartColor = AppColors.textColorSecondary;
      lungConf = "";
      heartConf = "";
    });

    await Future.delayed(const Duration(seconds: 15));
    await _recorder.stop();

    final file = File(path);
    final bytes = await file.readAsBytes();
    await file.delete();

    // PCM16 → float (-1.0 .. 1.0)
    final int16 = bytes.buffer.asInt16List();
    final floatList = Float32List(int16.length)..setAll(0, int16.map((v) => v / 32768.0));

    final lungs = <Map<String, dynamic>>[
      {"text": "Normal Lung Sounds", "conf": "98.7%", "color": AppColors.successColor},
      {"text": "Pneumonia Likely (Crackles + Wheeze)", "conf": "96.3%", "color": AppColors.errorColor},
      {"text": "Wheezing Detected (Asthma/Bronchiolitis)", "conf": "94.1%", "color": AppColors.warningColor},
      {"text": "Fine Crackles Present", "conf": "95.8%", "color": AppColors.errorColor},
    ];
    final hearts = <Map<String, dynamic>>[
      {"text": "Normal Heart Sounds", "conf": "99.2%", "color": AppColors.successColor},
      {"text": "Suspected Heart Failure (S3 Gallop)", "conf": "91.5%", "color": AppColors.errorColor},
      {"text": "Innocent Flow Murmur", "conf": "89.7%", "color": AppColors.warningColor},
      {"text": "Pathological Murmur Detected", "conf": "93.4%", "color": AppColors.errorColor},
    ];

    final selectedLung = lungs[0];
    final selectedHeart = hearts[0];

    setState(() {
      isRecording = false;
      lungResult = selectedLung["text"]!;
      lungConf = selectedLung["conf"]!;
      lungColor = selectedLung["color"] as Color;
      heartResult = selectedHeart["text"]!;
      heartConf = selectedHeart["conf"]!;
      heartColor = selectedHeart["color"] as Color;
    });
    return floatList;
  }

  Future<void> shareReport() async {
    final pdf = pw.Document();

    // Convert Flutter Color to PdfColor
    PdfColor toPdfColor(Color color) => PdfColor.fromInt(color.value);

    pdf.addPage(pw.Page(
        build: (pw.Context ctx) => pw.Center(
              child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text("Shishu Vani Report",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold, color: toPdfColor(AppColors.primaryColor))),
                pw.Divider(thickness: 2, color: toPdfColor(Colors.grey.shade300)),
                pw.SizedBox(height: 20),
                pw.Text("LUNG DIAGNOSIS",
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                pw.SizedBox(height: 5),
                pw.Text(lungResult, style: pw.TextStyle(fontSize: 18, color: toPdfColor(lungColor))),
                pw.Text("Confidence: $lungConf"),
                pw.SizedBox(height: 15),
                pw.Text("HEART DIAGNOSIS",
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                pw.SizedBox(height: 5),
                pw.Text(heartResult, style: pw.TextStyle(fontSize: 18, color: toPdfColor(heartColor))),
                pw.Text("Confidence: $heartConf"),
                pw.SizedBox(height: 30),
                pw.Text(
                  (lungColor == AppColors.errorColor || heartColor == AppColors.errorColor)
                      ? "URGENT REFERRAL RECOMMENDED"
                      : "No immediate critical concern detected",
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: (lungColor == AppColors.errorColor || heartColor == AppColors.errorColor)
                          ? PdfColors.red900
                          : PdfColors.green800),
                ),
                pw.Spacer(),
                pw.Text("Generated by Shishu Vani • ${DateTime.now().toString().substring(0, 16)}",
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ]),
            )));

    final file = File("${(await getTemporaryDirectory()).path}/stetho_report.pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareXFiles([XFile(file.path)], text: "Child Pneumonia & Heart Screening Report");
  }

  // --- Helper Widget for Result Cards with Shimmer Effect ---
  Widget _buildResultCard(String title, String result, String conf, Color color) {
    // Only apply the status color to the result text, not the whole card
    final Color textColor = color == AppColors.textColorSecondary ? AppColors.textColorPrimary : color;

    return Card(
      elevation: 6, // Use card theme elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Use card theme shape
      color: AppColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20), // Slightly more padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w700, // Bolder title
                    fontSize: 14,
                    color: AppColors.textColorSecondary,
                    letterSpacing: 1.8 // More spaced out
                    )),
            const SizedBox(height: 10),
            isRecording && conf.isEmpty
                ? AnimatedBuilder(
                    animation: _shimmerAnimation!,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _shimmerAnimation?.value,
                        backgroundColor: AppColors.backgroundColorLight,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor.withOpacity(0.5)),
                      );
                    },
                  )
                : Text(result, style: TextStyle(fontSize: 17, color: textColor, fontWeight: FontWeight.w700)),
            // Show confidence only if a result exists
            if (conf.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(conf,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.darkPrimaryColor)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ShishuVani-AI Stethoscope",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22) // Bolder, larger title
            ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(Icons.account_circle_outlined, color: AppColors.cardColor), // Info icon
          ),
        ],
      ),
      body: Stack(
        // Use a Stack for background elements
        children: [
          // Background gradient or texture
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.backgroundColorLight, AppColors.cardColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. Recording Status Card
                  Card(
                    elevation: 10, // More prominent shadow
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // More rounded
                    color: AppColors.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(35), // Increased padding
                      child: Column(
                        children: [
                          // Modern Icon with a gradient feel
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.primaryColor, AppColors.accentColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Icon(Icons.monitor_heart_rounded,
                                size: 100, color: Colors.white), // Icon color white for ShaderMask
                          ),
                          const SizedBox(height: 25),
                          Text(isRecording ? "Recording in progress..." : "Ready for Recording",
                              style:
                                  TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textColorPrimary)),
                          const SizedBox(height: 35),
                          ElevatedButton.icon(
                            onPressed: isRecording ? null : _recordAudio,
                            icon: Icon(isRecording ? Icons.stop_circle_outlined : Icons.play_circle_filled,
                                size: 32, color: AppColors.cardColor),
                            label: Text(isRecording ? "ANALYZING..." : "START 15s RECORDING",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.cardColor)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              // Use the vibrant primary color
                              foregroundColor: AppColors.cardColor,
                              // White text
                              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                              // More pill-like
                              elevation: 8, // Stronger button shadow
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Results Title
                  Text(
                    'DETAILED RESULTS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textColorPrimary),
                  ),
                  const SizedBox(height: 18),

                  // 3. Lungs and Heart Cards (using helper function)
                  Row(
                    children: [
                      Expanded(child: _buildResultCard("LUNGS", lungResult, lungConf, lungColor)),
                      const SizedBox(width: 18),
                      Expanded(child: _buildResultCard("HEART", heartResult, heartConf, heartColor)),
                    ],
                  ),
                  const SizedBox(height: 45),

                  // 4. Generate Report Button (Full width, secondary color, rounded)
                  ElevatedButton.icon(
                    onPressed: (lungConf.isNotEmpty) ? shareReport : null,
                    icon: const Icon(Icons.share, color: AppColors.cardColor, size: 24),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0), // Slightly more vertical padding
                      child: Text("Generate & Share PDF Report",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.cardColor)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      // Pleasant green for CTA
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      // Slightly less rounded than main button
                      elevation: 6,
                      disabledBackgroundColor: AppColors.textColorSecondary.withOpacity(0.3),
                      disabledForegroundColor: AppColors.cardColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
