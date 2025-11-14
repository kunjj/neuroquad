import 'package:ai_stetho_final/auth/screens/widgets/baby_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/dash_board_screen.dart';
import '../../services/baby_info_service.dart';
import '../../utils/app_color.dart';

class BabyInfoScreen extends StatefulWidget {
  const BabyInfoScreen({super.key});

  @override
  State<BabyInfoScreen> createState() => _BabyInfoScreenState();
}

class _BabyInfoScreenState extends State<BabyInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final parentController = TextEditingController();

  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: Stack(
        children: [
          // TOP CURVED BACKGROUND
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.accentColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------ SKIP BUTTON ------------------
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StethoScreen()),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.cardColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------ TITLE ---------------------
                  Center(
                    child: Text(
                      "Baby Information",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: AppColors.cardColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      "Please fill the details below",
                      style: GoogleFonts.poppins(
                        color: AppColors.cardColor.withOpacity(0.9),
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ===================== FORM CARD =========================
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkPrimaryColor.withOpacity(0.2),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Enter Baby Details",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Baby Name
                          _inputBox(
                            controller: nameController,
                            label: "Baby Name",
                            icon: Icons.child_care,
                          ),

                          const SizedBox(height: 18),

                          // Age
                          _inputBox(
                            controller: ageController,
                            label: "Age (months)",
                            icon: Icons.calendar_month,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) return "Enter age";
                              final age = int.tryParse(value);
                              if (age == null || age < 0 || age > 60) {
                                return "Age must be 0–60";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // Weight
                          _inputBox(
                            controller: weightController,
                            label: "Weight (kg)",
                            icon: Icons.monitor_weight,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                          ),

                          const SizedBox(height: 18),

                          // Parent Name
                          _inputBox(
                            controller: parentController,
                            label: "Parent Name",
                            icon: Icons.person,
                          ),

                          const SizedBox(height: 25),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Gender",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColorPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _genderChip("Male"),
                              _genderChip("Female"),
                              _genderChip("Other"),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // ---------------- CONTINUE BUTTON -----------------
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await BabyService.saveBabyData(
                                    name: nameController.text,
                                    age: ageController.text,
                                    weight: weightController.text,
                                    gender: gender,
                                    parent: parentController.text,
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const StethoScreen()),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ INPUT FIELD --------------------
// ------------------ BEAUTIFUL INPUT FIELD --------------------
  Widget _inputBox({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: TextStyle(
        color: AppColors.textColorPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      // Hide the counter
      buildCounter: (context,
          {required currentLength, required maxLength, required isFocused}) {
        return null;
      },

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textColorSecondary,
          fontSize: 15,
        ),

        prefixIcon: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 22,
        ),

        filled: true,
        fillColor: AppColors.cardColor.withOpacity(0.9),

        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

        // Normal border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.textColorSecondary.withOpacity(0.3),
            width: 1.2,
          ),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.8,
          ),
        ),

        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.5,
          ),
        ),

        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.8,
          ),
        ),
      ),
    );
  }

  // ------------------ GENDER CHIP --------------------
  Widget _genderChip(String value) {
    bool selected = gender == value;

    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : AppColors.backgroundColorLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : AppColors.textColorPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
