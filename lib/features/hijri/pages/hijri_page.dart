import 'package:flutter/material.dart';

class HijriPage extends StatelessWidget {
  const HijriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("হিজরি"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: const Center(
        child: Text(
          "হিজরি",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}