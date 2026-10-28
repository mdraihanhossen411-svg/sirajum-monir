import 'package:flutter/material.dart';

import '../data/bukhari_ifa_data.dart';
import 'hadith_search_results_page.dart';

import '../data/bukhari_books_data.dart';
import 'bukhari_author_page.dart';
import 'bukhari_book_chapters_page.dart';

class BukhariHomePage extends StatefulWidget {
  const BukhariHomePage({super.key});

  @override
  State<BukhariHomePage> createState() => _BukhariHomePageState();
}

class _BukhariHomePageState extends State<BukhariHomePage> {
  final TextEditingController _searchController =
      TextEditingController();

  bool _searching = false;

  static const Color _green = Color(0xFF087A3B);

  String _bn(int n) {
    const d = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    return n
        .toString()
        .split('')
        .map((e) => d[int.parse(e)])
        .join();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() {
      _searching = true;
    });
  }

  void _closeSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searching = false;
      _searchController.clear();
    });
  }

  String _normalize(String value) {
    const map = {
      '০': '0',
      '১': '1',
      '২': '2',
      '৩': '3',
      '৪': '4',
      '৫': '5',
      '৬': '6',
      '৭': '7',
      '৮': '8',
      '৯': '9',
    };

    return value
        .trim()
        .toLowerCase()
        .split('')
        .map((c) => map[c] ?? c)
        .join();
  }

  void _search() {
    FocusScope.of(context).unfocus();

    final query = _normalize(_searchController.text);
    final results = <HadithSearchResult>[];

    if (query.isNotEmpty) {
      for (var bookNumber = 1; bookNumber <= 97; bookNumber++) {
        final book = BukhariBooksData.books.firstWhere(
          (item) => item.number == bookNumber,
        );

        final bookMatches =
            _normalize(book.bengaliName).contains(query) ||
            _normalize(book.arabicName).contains(query) ||
            _normalize(book.number.toString()).contains(query);

        final hadiths =
            BukhariIfaData.hadithsForBook(bookNumber);

        for (final hadith in hadiths) {
          final hadithMatches =
              _normalize(hadith.number.toString()).contains(query) ||
              _normalize(hadith.arabic).contains(query) ||
              _normalize(hadith.bengali).contains(query);

          if (bookMatches || hadithMatches) {
            results.add(
              HadithSearchResult(
                bookName: book.bengaliName,
                bookNumber: bookNumber,
                hadith: hadith,
              ),
            );
          }
        }
      }
    }

    setState(() {
      _searching = false;
      _searchController.clear();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HadithSearchResultsPage(
          results: results,
        ),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'হাদিস / কিতাব সার্চ',
                    style: TextStyle(
                      color: _green,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'বন্ধ করুন',
                  onPressed: _closeSearch,
                  icon: const Icon(Icons.close_rounded),
                  color: _green,
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'কিতাবের বা অধ্যায়ের নাম / হাদিস নম্বর',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _green,
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: _green,
                    width: 1.4,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _search,
                icon: const Icon(Icons.search_rounded),
                label: const Text('সার্চ করুন'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF4),
      appBar: AppBar(
        title: const Text(
          'সহীহ বুখারী',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF087A3B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _searching ? 'বন্ধ করুন' : 'সার্চ করুন',
            icon: Icon(
              _searching
                  ? Icons.close_rounded
                  : Icons.search_rounded,
            ),
            onPressed: _searching ? _closeSearch : _openSearch,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          if (_searching) _buildSearchPanel(),
          Card(
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BukhariAuthorPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D58A).withValues(alpha: 0.28),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF087A3B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'লেখক পরিচিতি',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF063B25),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFC9A227),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...BukhariBooksData.books.map(
            (book) => Card(
              elevation: 0.8,
              margin: const EdgeInsets.only(bottom: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BukhariBookChaptersPage(book: book),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF087A3B).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          _bn(book.number),
                          style: const TextStyle(
                            color: Color(0xFF087A3B),
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.bengaliName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : const Color(0xFF17271E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                book.arabicName,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.45,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF063B25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 21,
                        color: Color(0xFFC9A227),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
