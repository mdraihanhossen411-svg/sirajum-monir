import 'package:flutter/material.dart';

class HajjUmrahPage extends StatelessWidget {
  const HajjUmrahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হজ ও উমরাহ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.auto_awesome,
              size: 52,
              color: Color(0xFFC9A227),
            ),
            SizedBox(height: 12),
            Text(
              'হজ ও উমরাহ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
