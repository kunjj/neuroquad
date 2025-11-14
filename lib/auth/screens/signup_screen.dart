import 'package:ai_stetho_final/auth/screens/add_baby_info_screen.dart';
import 'package:ai_stetho_final/auth/screens/widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/baby_info_service.dart';
import '../../shishuvani/shishuvani.dart';
import '../../utils/app_color.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  String? selectedGender;
  bool hidePass = true;
  bool hideConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.accentColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  // HEADER
                  Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 34,
                      color: AppColors.cardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Register to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.cardColor.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FORM CARD
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomInputField(
                              controller: nameCtrl,
                              label: "Parent Name",
                              icon: Icons.person,
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),

                            const SizedBox(height: 20),

                            CustomInputField(
                              controller: emailCtrl,
                              label: "Email",
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty ? "Email required" : null,
                            ),

                            const SizedBox(height: 20),

                            CustomInputField(
                              controller: mobileCtrl,
                              label: "Mobile Number",
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Required";
                                if (v.length != 10) return "Enter valid 10-digit mobile number";
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // GENDER DROPDOWN
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.textColorSecondary.withOpacity(0.3)),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                decoration: const InputDecoration(border: InputBorder.none),
                                hint: Text("Select Gender",
                                    style: TextStyle(
                                      color: AppColors.textColorPrimary,
                                    )),
                                items: ["Male", "Female", "Other"]
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() => selectedGender = value),
                                validator: (v) => v == null ? "Select gender" : null,
                              ),
                            ),

                            const SizedBox(height: 20),
                            CustomInputField(
                              controller: passCtrl,
                              label: "Password",
                              icon: Icons.lock,
                              obscure: hidePass,
                              onToggle: () => setState(() => hidePass = !hidePass),
                              validator: (v) => v!.isEmpty ? "Password required" : null,
                            ),

                            const SizedBox(height: 20),

                            CustomInputField(
                              controller: confirmPassCtrl,
                              label: "Confirm Password",
                              icon: Icons.lock,
                              obscure: hideConfirmPass,
                              onToggle: () => setState(() => hideConfirmPass = !hideConfirmPass),
                              validator: (v) {
                                if (v!.isEmpty) return "Confirm password";
                                if (v != passCtrl.text) return "Passwords do not match";
                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            // SIGN UP BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onSignUpPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.cardColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // LOGIN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: AppColors.textColorPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // INPUT DECORATION
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textColorPrimary),
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.textColorSecondary, width: 1),
      ),
    );
  }

// SIGN UP ACTION
  Future<void> _onSignUpPressed() async {
    if (_formKey.currentState!.validate()) {
      await AuthService.saveUser(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      final children = await BabyService.getAllChildren();

      if (children.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ShishuVaniScreen()),
        );
      } else {
        // No child_info stored → go to Add Baby Info screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AddBabyInfoScreen(screenName: '')),
        );
      }
    }
  }
}
