import 'package:flutter/material.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("তাসবীহ"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: const Center(
        child: Text(
          "তাসবীহ",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}