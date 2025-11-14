import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final int? maxLength;

  final VoidCallback? onToggle;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,

      // Hide counter
      buildCounter: (
        BuildContext context, {
        required int currentLength,
        required int? maxLength,
        required bool isFocused,
      }) {
        return null;
      },

      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textColorPrimary),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),

        // 👇 Added Visibility Toggle Correctly
        suffixIcon: onToggle != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primaryColor,
                ),
                onPressed: onToggle,
              )
            : null,

        filled: true,
        fillColor: AppColors.cardColor.withOpacity(0.90),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.textColorSecondary.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.5,
          ),
        ),
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
}
