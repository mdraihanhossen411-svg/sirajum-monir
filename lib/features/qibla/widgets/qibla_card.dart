import 'package:flutter/material.dart';

class QiblaCard extends StatelessWidget {
  const QiblaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF0A8754),
          child: Icon(
            Icons.explore,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "কিবলা দিক",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: const Text(
          "কাবার দিক নির্ণয় করুন",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}