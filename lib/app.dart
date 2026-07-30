import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

import 'screens/splash/splash_screen.dart';

class SirajumMonirApp extends StatelessWidget {
  const SirajumMonirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sirajum Monir",

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.system,

      home: const SplashScreen(),
    );
  }
}
