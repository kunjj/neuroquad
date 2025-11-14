import 'package:ai_stetho_final/services/baby_info_service.dart';
import 'package:flutter/material.dart';
import 'auth/screens/baby_info_screen.dart';
import 'services/auth_service.dart';
import 'auth/screens/login_screen.dart';
import 'home/dash_board_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool logged = await AuthService.isLoggedIn();
  bool babySaved = false;

  if (logged) {
    babySaved = await BabyService.isBabySaved();
  }

  runApp(MyApp(
    logged: logged ?? false,
    babySaved: babySaved ?? false,
  ));
}

class MyApp extends StatelessWidget {
  final bool logged;
  final bool babySaved;

  const MyApp({
    super.key,
    required this.logged,
    required this.babySaved,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: logged
          ? (babySaved ? const StethoScreen() : const BabyInfoScreen())
          : const LoginScreen(),
    );
  }
}
