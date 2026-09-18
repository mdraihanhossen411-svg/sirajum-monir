import 'package:flutter/material.dart';

class BookCategoryCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const BookCategoryCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.menu_book,
          color: Color(0xFF087A3B),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
