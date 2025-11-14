import 'package:ai_stetho_final/services/baby_info_service.dart';
import 'package:ai_stetho_final/shishuvani/shishuvani.dart';
import 'package:ai_stetho_final/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'auth/screens/add_baby_info_screen.dart';
import 'services/auth_service.dart';
import 'auth/screens/login_screen.dart';

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
      title: 'Shishu Vani',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.backgroundColorLight,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.cardColor,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 6, // Slightly more pronounced shadow
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // More rounded
          )),
      home: logged
          ? (hasChildren ? const ShishuVaniScreen() : const AddBabyInfoScreen(screenName:''))
          : const LoginScreen(),
    );
  }
}
