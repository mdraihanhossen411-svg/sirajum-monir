import 'package:flutter/material.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al Quran"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "114 Surahs will appear here",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
