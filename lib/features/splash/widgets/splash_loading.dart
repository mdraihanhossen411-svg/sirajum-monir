import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 15),
        Text(
          "Loading...",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}