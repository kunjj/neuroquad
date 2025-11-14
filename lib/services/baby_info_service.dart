import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BabyService {
  static const String keyChildren = "children_list";
  static final Uuid uuid = Uuid();

  static Future<void> saveChild({
    required String name,
    required String age,
    required String weight,
    required String gender,
    required String parent,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final child = {
      "id": uuid.v4(),
      "name": name,
      "age": age,
      "weight": weight,
      "gender": gender,
      "parent": parent,
    };

    List<String> list = prefs.getStringList(keyChildren) ?? [];
    list.add(jsonEncode(child));

    await prefs.setStringList(keyChildren, list);
  }

  static Future<List<Map<String, String>>> getAllChildren() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> storedList = prefs.getStringList(keyChildren) ?? [];

    return storedList
        .map((item) => Map<String, String>.from(jsonDecode(item)))
        .toList();
  }

  static Future<Map<String, String>?> getChildById(String id) async {
    final children = await getAllChildren();

    try {
      return children.firstWhere((child) => child["id"] == id);
    } catch (e) {
      return null;
    }
  }
}
