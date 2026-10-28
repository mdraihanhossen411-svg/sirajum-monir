import 'package:flutter/material.dart';

import '../data/bukhari_ifa_data.dart';
import '../models/bukhari_hadith.dart';
import 'bukhari_home_page.dart';
import 'hadith_search_results_page.dart';

class HadithPage extends StatefulWidget {
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
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  static const Color _green = Color(0xFF087A3B);

  final TextEditingController _searchController =
      TextEditingController();

  final Set<String> _selectedBooks = {'সহীহ বুখারী'};

  static const List<String> _availableBooks = [
    'সহীহ বুখারী',
  ];

  bool _searching = false;


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }



  bool _matches(BukhariHadith hadith, String query) {
    if (query.isEmpty) {
      return true;
    }

    final normalizedQuery = _normalize(query);

    final fields = [
      _normalize(hadith.internationalNumber),
      _normalize(hadith.chapter),
      _normalize(hadith.narrator),
      _normalize(hadith.arabic),
      _normalize(hadith.bengali),
      _normalize(hadith.note),
    ];

    return fields.any(
      (field) => field.contains(normalizedQuery),
    );
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

  void _search() {
    FocusScope.of(context).unfocus();

    final query = _searchController.text.trim();
    final results = <HadithSearchResult>[];

    if (_selectedBooks.contains('সহীহ বুখারী')) {
      for (var bookNumber = 1; bookNumber <= 97; bookNumber++) {
        final hadiths =
            BukhariIfaData.hadithsForBook(bookNumber);

        for (final hadith in hadiths) {
          if (_matches(hadith, query)) {
            results.add(
              HadithSearchResult(
                bookName: 'সহীহ বুখারী',
                bookNumber: bookNumber,
                hadith: hadith,
              ),
            );
          }
        }
      }
    }

    setState(() {
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

  void _toggleBook(String book, bool selected) {
    setState(() {
      if (selected) {
        _selectedBooks.add(book);
      } else {
        _selectedBooks.remove(book);
      }
    });
  }

  void _selectAllAvailable() {
    setState(() {
      _selectedBooks
        ..clear()
        ..addAll(_availableBooks);
    });
  }

  void _clearBooks() {
    setState(() {
      _selectedBooks.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        title: const Text(
          'হাদিস শরীফ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _searching
                ? 'বন্ধ করুন'
                : 'হাদিস খুঁজুন',
            icon: Icon(
              _searching
                  ? Icons.close_rounded
                  : Icons.search_rounded,
            ),
            onPressed:
                _searching ? _closeSearch : _openSearch,
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          12,
          10,
          12,
          24,
        ),
        children: [

          // একই পেজের ছোট Search Panel
          if (_searching) _buildSearchPanel(),

          // Search result
                      ...HadithPage.books
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final book = entry.value;

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
                    backgroundColor:
                        const Color(0xFFE8F5EE),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: _green,
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
                          builder: (_) =>
                              const BukhariHomePage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content:
                              Text('$book শীঘ্রই যুক্ত হবে'),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _green.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            'হাদিস অনুসন্ধান',
            style: TextStyle(
              color: _green,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 9),

          TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,

            onChanged: (_) {
              setState(() {});
            },

            onSubmitted: (_) => _search(),

            decoration: InputDecoration(
              hintText: 'হাদিস নাম্বার / শব্দ',
              prefixIcon:
                  const Icon(Icons.search_rounded),

              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                          tooltip: 'মুছে ফেলুন',
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                          ),
                        )
                      : null,

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),

              focusedBorder:
                  const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide(
                  color: _green,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'পছন্দের বই নির্বাচন',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              TextButton(
                onPressed: _selectAllAvailable,
                child: const Text('সব'),
              ),

              TextButton(
                onPressed: _clearBooks,
                child: const Text('বাদ'),
              ),
            ],
          ),

          ...HadithPage.books.map((book) {
            final available =
                _availableBooks.contains(book);
            final selected =
                _selectedBooks.contains(book);

            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,

              value: selected,

              onChanged: available
                  ? (value) {
                      _toggleBook(
                        book,
                        value ?? false,
                      );
                    }
                  : null,

              activeColor: _green,

              title: Text(
                book,
                style: TextStyle(
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: available
                      ? null
                      : Colors.grey.shade500,
                ),
              ),

              subtitle: Text(
                available
                    ? 'ডেটা উপলব্ধ'
                    : 'শীঘ্রই যুক্ত হবে',
              ),

              controlAffinity:
                  ListTileControlAffinity.leading,
            );
          }),

          const SizedBox(height: 4),

          SizedBox(
            height: 46,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _selectedBooks.isEmpty
                      ? null
                      : _search,

              icon: const Icon(
                Icons.search_rounded,
              ),

              label: const Text(
                'সার্চ করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
