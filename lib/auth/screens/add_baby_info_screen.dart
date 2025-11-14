import 'package:ai_stetho_final/shishuvani/shishuvani.dart';
import 'package:flutter/material.dart';

import '../../services/baby_info_service.dart';
import '../../utils/app_color.dart';

class AddBabyInfoScreen extends StatefulWidget {
  final String screenName;

  const AddBabyInfoScreen({super.key, required this.screenName});

  @override
  State<AddBabyInfoScreen> createState() => _AddBabyInfoScreenState();
}

class _AddBabyInfoScreenState extends State<AddBabyInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final parentController = TextEditingController();

  String gender = "Male";

  @override
  void initState() {
    super.initState();
    print("Received parentId: ${widget.screenName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: Stack(
        children: [
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
                  Row(
                    children: [
                      if (widget.screenName == 'list_screen')
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.cardColor,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      Spacer(),
                      if (widget.screenName == '')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ShishuVaniScreen()),
                              ),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.cardColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Baby Information",
                      style: TextStyle(
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
                      style: TextStyle(
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
                            style: TextStyle(
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
                              style: TextStyle(
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

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await BabyService.saveChild(
                                    name: nameController.text.trim(),
                                    age: ageController.text.trim(),
                                    weight: weightController.text.trim(),
                                    gender: gender,
                                    parent: parentController.text.trim(),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ShishuVaniScreen()),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 6,
                              ),
                              child: Text(
                                "Continue",
                                style: TextStyle(
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
      buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
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

        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

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
          color: selected ? AppColors.primaryColor : AppColors.backgroundColorLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textColorPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
