import 'package:flutter/material.dart';

import '../data/bukhari_books_data.dart';
import 'bukhari_book_chapters_page.dart';

class BukhariBooksPage extends StatefulWidget {
  const BukhariBooksPage({super.key});

  @override
  State<BukhariBooksPage> createState() => _BukhariBooksPageState();
}

class _BukhariBooksPageState extends State<BukhariBooksPage> {
  static const _green = Color(0xFF087A3B);
  static const _gold = Color(0xFFC9A227);

  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  String _bnNumber(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((c) => bn[en.indexOf(c)])
        .join();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBook(BuildContext context, int index) {
    final book = _filteredBooks[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BukhariBookChaptersPage(book: book),
      ),
    );
  }

  List<dynamic> get _filteredBooks {
    final books = BukhariBooksData.books;

    if (_query.trim().isEmpty) {
      return books;
    }

    final query = _query.trim().toLowerCase();

    return books.where((book) {
      return book.bengaliName.toLowerCase().contains(query) ||
          book.arabicName.toLowerCase().contains(query) ||
          book.number.toString().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

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
      body: Column(
        children: [
          // অধ্যায় সার্চ
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'অধ্যায় খুঁজুন',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _green,
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        tooltip: 'মুছে ফেলুন',
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: _gold.withValues(alpha: 0.25),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: _gold.withValues(alpha: 0.25),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: _green,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 52,
                          color: _green.withValues(alpha: 0.55),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'কোনো অধ্যায় পাওয়া যায়নি',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'অন্য কোনো নাম দিয়ে চেষ্টা করুন',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
          ),
        ],
      ),
    );
  }
}
