import 'package:ai_stetho_final/services/baby_info_service.dart';
import 'package:flutter/material.dart';
import 'auth/screens/add_baby_info_screen.dart';
import 'services/auth_service.dart';
import 'auth/screens/login_screen.dart';
import 'home/dash_board_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool logged = await AuthService.isLoggedIn();
  bool hasChildren = false;

  if (logged) {
    final children = await BabyService.getAllChildren();
    hasChildren = children.isNotEmpty;
  }

  runApp(MyApp(
    logged: logged,
    hasChildren: hasChildren,
  ));
}

class MyApp extends StatelessWidget {
  final bool logged;
  final bool hasChildren;

  const MyApp({
    super.key,
    required this.logged,
    required this.hasChildren,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: logged
          ? (hasChildren ? const StethoScreen() : const AddBabyInfoScreen(screenName:''))
          : const LoginScreen(),
    );
  }
}
