import 'package:flutter/material.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("কিবলা"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: const Center(
        child: Text(
          "কিবলা",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}