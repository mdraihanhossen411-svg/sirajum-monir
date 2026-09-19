import 'package:flutter/material.dart';

import '../data/bukhari_author_data.dart';

class BukhariAuthorPage extends StatelessWidget {
  const BukhariAuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('লেখক পরিচিতি'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0A8754),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BukhariAuthorData.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'আবু আব্দুল্লাহ • আমীরুল মুমিনীন ফিল হাদীস',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final section in BukhariAuthorData.sections)
            _SectionCard(section: section),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final BukhariAuthorSection section;

  const _SectionCard({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: const TextStyle(
                color: Color(0xFF0A8754),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              section.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
