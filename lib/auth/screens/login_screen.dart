import 'package:ai_stetho_final/auth/screens/widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/dash_board_screen.dart';
import '../../services/auth_service.dart';
import '../../services/baby_info_service.dart';
import '../../utils/app_color.dart';
import 'baby_info_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool hidePass = true;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // HEADER
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      color: AppColors.cardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.cardColor.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // GLASS CARD
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor.withOpacity(0.90),
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
                      child: Column(
                        children: [
                          // EMAIL FIELD
                          CustomInputField(
                            controller: emailCtrl,
                            label: "Email",
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 18),

                          // PASSWORD FIELD
                          CustomInputField(
                            controller: passCtrl,
                            label: "Password",
                            icon: Icons.lock,
                            obscure: hidePass,
                            onToggle: () =>
                                setState(() => hidePass = !hidePass),
                          ),

                          const SizedBox(height: 10),

                          if (error.isNotEmpty)
                            Text(
                              error,
                              style: TextStyle(
                                color: AppColors.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          const SizedBox(height: 25),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                bool ok = await AuthService.login(
                                  emailCtrl.text.trim(),
                                  passCtrl.text.trim(),
                                );

                                if (ok) {
                                  bool isSaved =
                                      await BabyService.isBabySaved();

                                  if (isSaved) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const StethoScreen()),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const BabyInfoScreen()),
                                    );
                                  }
                                } else {
                                  setState(() =>
                                      error = "Invalid email or password!");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 6,
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: AppColors.cardColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // SIGNUP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
