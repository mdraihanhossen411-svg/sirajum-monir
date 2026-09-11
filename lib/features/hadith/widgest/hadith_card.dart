import 'package:flutter/material.dart';

import '../models/hadith_models.dart';

class HadithCard extends StatelessWidget {
  final Hadith hadith;

  const HadithCard({
    super.key,
    required this.hadith,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'হাদিস নং ${hadith.hadithNumber}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (hadith.chapter.isNotEmpty)
              Text(
                hadith.chapter,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (hadith.narrator.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'বর্ণনাকারী: ${hadith.narrator}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (hadith.arabic.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF4F8F5),
                ),
                child: Text(
                  hadith.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.8,
                  ),
                ),
              ),
            ],
            if (hadith.bengali.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                hadith.bengali,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.8,
                ),
              ),
            ],
            if (hadith.grade.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'হাদিসের মান: ${hadith.grade}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (hadith.reference.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                hadith.reference,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'বুকমার্ক',
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
                IconButton(
                  tooltip: 'কপি',
                  onPressed: () {},
                  icon: const Icon(Icons.copy_outlined),
                ),
                IconButton(
                  tooltip: 'শেয়ার',
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
