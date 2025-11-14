import 'package:shared_preferences/shared_preferences.dart';

class BabyService {
  static const String keyName = "baby_name";
  static const String keyAge = "baby_age";
  static const String keyWeight = "baby_weight";
  static const String keyGender = "baby_gender";
  static const String keyParent = "baby_parent";
  static const String keySaved = "baby_saved";

  // SAVE DATA
  static Future<void> saveBabyData({
    required String name,
    required String age,
    required String weight,
    required String gender,
    required String parent,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(keyName, name);
    await prefs.setString(keyAge, age);
    await prefs.setString(keyWeight, weight);
    await prefs.setString(keyGender, gender);
    await prefs.setString(keyParent, parent);

    await prefs.setBool(keySaved, true);
  }

  // CHECK BABY SAVED
  static Future<bool> isBabySaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keySaved) ?? false;
  }

  // GET BABY DETAILS
  static Future<Map<String, String>> getBabyData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString(keyName) ?? "",
      "age": prefs.getString(keyAge) ?? "",
      "weight": prefs.getString(keyWeight) ?? "",
      "gender": prefs.getString(keyGender) ?? "",
      "parent": prefs.getString(keyParent) ?? "",
    };
  }
}
