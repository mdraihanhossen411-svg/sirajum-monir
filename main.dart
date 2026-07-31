import 'package:flutter/material.dart';

void main() {
  runApp(const SirajumMonirApp());
}

class SirajumMonirApp extends StatelessWidget {
  const SirajumMonirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sirajum Monir',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sirajum Monir"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "السلام عليكم\n\nSirajum Monir এ স্বাগতম",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
