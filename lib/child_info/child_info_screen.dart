import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class ChildProfileScreen extends StatelessWidget {
  final Map<String, String> childData;

  const ChildProfileScreen({super.key, required this.childData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      appBar: AppBar(
        title: Text(childData["name"] ?? "Child"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.accentColor,
                      child: const Icon(Icons.child_care,
                          size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      childData["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                buildInfoRow("Age", childData["age"]),
                buildDivider(),
                buildInfoRow("Weight", childData["weight"]),
                buildDivider(),
                buildInfoRow("Gender", childData["gender"]),
                buildDivider(),
                buildInfoRow("Parent", childData["parent"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textColorPrimary)),
        Text(value ?? "",
            style: const TextStyle(
                fontSize: 17, color: AppColors.textColorSecondary)),
      ],
    );
  }

  Widget buildDivider() {
    return Divider(
      height: 26,
      color: AppColors.primaryColor.withOpacity(0.3),
    );
  }
}
