import 'package:flutter/material.dart';

class AudioQuranPage extends StatelessWidget {
  const AudioQuranPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio কুরআন শরীফ'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        color: cream,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: gold, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.headphones,
                    size: 72,
                    color: green,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Audio কুরআন শরীফ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: deepGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'অডিও তিলাওয়াতের সুবিধা শীঘ্রই যুক্ত করা হবে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'শীঘ্রই আসছে',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
