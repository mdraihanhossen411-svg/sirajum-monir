import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ইসলামী বুক / PDF')),
      body: const Center(
        child: Text('ইসলামী বুক / PDF'),
      ),
    );
  }
}
