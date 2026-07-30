
import 'package:flutter/material.dart';

class SurahDetailsScreen extends StatelessWidget {
  final String id;
  final String name;
  final String arabic;

  const SurahDetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.arabic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              arabic,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 30),
            const Text(
        
              "Surah content will be loaded here.",
              style: TextStyle(fontSize: 18),
    
