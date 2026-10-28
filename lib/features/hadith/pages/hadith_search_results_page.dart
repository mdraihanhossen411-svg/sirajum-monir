import 'package:flutter/material.dart';

import '../models/bukhari_hadith.dart';
import 'bukhari_book_chapters_page.dart';
import '../data/bukhari_books_data.dart';

class HadithSearchResult {
  final String bookName;
  final int bookNumber;
  final BukhariHadith hadith;

  const HadithSearchResult({
    required this.bookName,
    required this.bookNumber,
    required this.hadith,
  });
}

class HadithSearchResultsPage extends StatelessWidget {
  final List<HadithSearchResult> results;

  const HadithSearchResultsPage({
    super.key,
    required this.results,
  });

  static const Color _green = Color(0xFF087A3B);
  String _banglaDigits(int n) {
    const d = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];

    return n
        .toString()
        .split('')
        .map((e) => d[int.parse(e)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF4),
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'সার্চ রেজাল্ট',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                'কোনো হাদিস পাওয়া যায়নি',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];

                return _SearchResultCard(
                  result: result,
                  banglaDigits: _banglaDigits,
                );
              },
            ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final HadithSearchResult result;
  final String Function(int) banglaDigits;

  const _SearchResultCard({
    required this.result,
    required this.banglaDigits,
  });

  static const Color _green = Color(0xFF087A3B);
  static const Color _gold = Color(0xFFC9A227);
  @override
  Widget build(BuildContext context) {
    final hadith = result.hadith;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          final book = BukhariBooksData.books.firstWhere(
            (item) => item.number == result.bookNumber,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BukhariBookChaptersPage(
                book: book,
                initialHadithNumber: hadith.number,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.bookName,
                      style: const TextStyle(
                        color: _green,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _gold.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      'হাদিস ${banglaDigits(hadith.number)}',
                      style: const TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                hadith.arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'বাংলা অনুবাদ',
                style: TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                hadith.bengali,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.65,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
