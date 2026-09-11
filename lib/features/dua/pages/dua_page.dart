import 'package:flutter/material.dart';

class DuaPage extends StatelessWidget {
  const DuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("দোয়া"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: const Center(
        child: Text(
          "দোয়া",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}