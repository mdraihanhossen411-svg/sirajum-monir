import 'package:flutter/material.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Version 1.0.0",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Developed by Mohammad Raihan Siddiki",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}