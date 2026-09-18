import 'package:flutter/material.dart';

class TafsirCard extends StatelessWidget {
  final String title;
  final String source;

  const TafsirCard({
    super.key,
    required this.title,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.auto_stories,
          color: Color(0xFF087A3B),
        ),
        title: Text(title),
        subtitle: Text(source),
      ),
    );
  }
}
