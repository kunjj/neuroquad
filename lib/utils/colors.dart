import 'package:flutter/material.dart';

class AppColors {
  // --- Core Colors: Trust, Professionalism, and Action ---
  static const Color primaryColor = Color(0xFF00A896);      // Calm Teal: Main brand color.
  static const Color darkPrimaryColor = Color(0xFF2C3E50);  // Navy Slate: For App Bar background and high-impact text.
  static const Color accentColor = Color(0xFFFF6F61);       // Vibrant Coral: RESERVED for the main Call-to-Action (e.g., "Start Recording").

  // --- Neutrals: Clarity, Legibility, and Hierarchy ---
  static const Color backgroundColorLight = Color(0xFFF9FBFB); // Soft Cream: Scaffold background for a clean, non-clinical feel.
  static const Color cardColor = Colors.white;               // Pure White: Card background for maximum contrast and readability.
  static const Color textColorPrimary = Color(0xFF34495E);   // Deep Charcoal: Primary text, ensuring high legibility.
  static const Color textColorSecondary = Color(0xFF95A5A6); // Cool Gray: For confidence scores, hints, and subtle details.

  // --- Status Colors: Instant Feedback and High Contrast ---
  static const Color errorColor = Color(0xFFE74C3C);        // Soft Red: Critical alerts ("URGENT REFERRAL").
  static const Color warningColor = Color(0xFFF39C12);       // Deep Gold: Caution/Warning ("Wheezing Detected").
  static const Color successColor = Color(0xFF2ECC71);      // Emerald Green: Normal status and successful completion (PDF Share).
}