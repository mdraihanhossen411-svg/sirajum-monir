import 'package:flutter/material.dart';

import 'bukhari_home_page.dart';

class HadithPage extends StatelessWidget {
  const HadithPage({super.key});

  static const List<String> books = [
    'সহীহ বুখারী',
    'সহীহ মুসলিম',
    'সুনানে নাসায়ী',
    'সুনান আবু দাউদ',
    'জামে আত-তিরমিযী',
    'সুনান ইবনে মাজাহ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হাদিস শরীফ'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              minVerticalPadding: 10,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE8F5EE),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF0A8754),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                book,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BukhariHomePage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$book শীঘ্রই যুক্ত হবে'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
