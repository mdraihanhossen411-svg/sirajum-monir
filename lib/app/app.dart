import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'theme/theme_controller.dart';
import '../features/splash/pages/splash_page.dart';

class SirajumMonirApp extends StatefulWidget {
  const SirajumMonirApp({super.key});

  @override
  State<SirajumMonirApp> createState() => _SirajumMonirAppState();
}

class _SirajumMonirAppState extends State<SirajumMonirApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.load();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sirajum Monir',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.themeMode,
          home: SplashPage(),
        );
      },
    );
  }
}
