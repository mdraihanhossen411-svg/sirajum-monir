import 'package:flutter/material.dart';

class HadithPage extends StatelessWidget {
  const HadithPage({super.key});

  static const List<Map<String, String>> books = [
    {
      'name': 'সহীহ বুখারী',
      'author': 'ইমাম মুহাম্মদ ইবনে ইসমাঈল আল-বুখারী (রহ.)',
      'death': 'মৃত্যু ২৫৬ হিজরি',
    },
    {
      'name': 'সহীহ মুসলিম',
      'author': 'ইমাম মুসলিম ইবনুল হাজ্জাজ (রহ.)',
      'death': 'মৃত্যু ২৬১ হিজরি',
    },
    {
      'name': 'সুনানে নাসায়ী',
      'author': 'ইমাম আহমদ ইবনে শুআইব আন-নাসায়ী (রহ.)',
      'death': 'মৃত্যু ৩০৩ হিজরি',
    },
    {
      'name': 'সুনানে আবু দাউদ',
      'author': 'ইমাম আবু দাউদ সুলাইমান ইবনে আল-আশআস (রহ.)',
      'death': 'মৃত্যু ২৭৫ হিজরি',
    },
    {
      'name': 'জামে আত-তিরমিযী',
      'author': 'ইমাম আবু ঈসা মুহাম্মদ ইবনে ঈসা আত-তিরমিযী (রহ.)',
      'death': 'মৃত্যু ২৭৯ হিজরি',
    },
    {
      'name': 'সুনান ইবনে মাজাহ',
      'author': 'ইমাম মুহাম্মদ ইবনে ইয়াযিদ ইবনে মাজাহ (রহ.)',
      'death': 'মৃত্যু ২৭৩ হিজরি',
    },
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              leading: CircleAvatar(
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
                book['name']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${book['author']!}\n${book['death']!}',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
