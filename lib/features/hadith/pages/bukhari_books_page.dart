import 'package:flutter/material.dart';

import '../data/bukhari_books_data.dart';
import 'bukhari_book_chapters_page.dart';

class BukhariBooksPage extends StatelessWidget {
  const BukhariBooksPage({super.key});

  static const _green = Color(0xFF087A3B);
  static const _gold = Color(0xFFC9A227);

  String _bnNumber(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((c) => bn[en.indexOf(c)])
        .join();
  }

  void _openBook(BuildContext context, int index) {
    final book = BukhariBooksData.books[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BukhariBookChaptersPage(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = BukhariBooksData.books;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'সহীহ বুখারী',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 9),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: _gold.withValues(alpha: 0.18),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _openBook(context, index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        _bnNumber(book.number),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.bengaliName,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            book.arabicName,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: _gold,
                      size: 23,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
