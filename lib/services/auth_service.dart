import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyUsername = "username";
  static const String keyPassword = "password";
  static const String keyLogged = "isLoggedIn";

  // Save user while SignUp
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyPassword, password);
    await prefs.setBool(keyLogged, true); // Mark user as logged in
  }

  // Check login status
  // static Future<bool> isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(keyLogged) ?? false;
  // }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    bool? value = prefs.getBool(keyLogged);

    if (value == null) return false;

    return value;
  }

  // Validate login
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUser = prefs.getString(keyUsername);
    String? savedPass = prefs.getString(keyPassword);

    if (savedUser == username && savedPass == password) {
      await prefs.setBool(keyLogged, true); // FIX: Set logged-in flag
      return true;
    }

    return false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('baby_info_added');
  }
}
