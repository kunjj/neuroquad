import 'package:ai_stetho_final/shishuvani.dart';
import 'package:ai_stetho_final/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MainEntryPoint());

class MainEntryPoint extends StatefulWidget {
  const MainEntryPoint({super.key});

  @override
  State<MainEntryPoint> createState() => _MainEntryPointState();
}

class _MainEntryPointState extends State<MainEntryPoint> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shishu Vani',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: AppColors.backgroundColorLight,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.cardColor,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 6, // Slightly more pronounced shadow
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // More rounded
          )),
      home: const ShishuVaniScreen(),
    );
  }
}
