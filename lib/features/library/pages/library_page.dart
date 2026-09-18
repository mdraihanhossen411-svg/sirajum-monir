import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    final items = [
      _LibraryItem('প্রিয় আয়াত', Icons.menu_book, 'কুরআনের প্রিয় আয়াত'),
      _LibraryItem('বুকমার্ক', Icons.bookmark, 'সংরক্ষিত পাঠ'),
      _LibraryItem('প্রিয় হাদিস', Icons.library_books, 'সংরক্ষিত হাদিস'),
      _LibraryItem('প্রিয় দোয়া', Icons.volunteer_activism, 'সংরক্ষিত দোয়া'),
      _LibraryItem('প্রিয় বই', Icons.import_contacts, 'পছন্দের বই ও PDF'),
      _LibraryItem('সম্প্রতি পড়া', Icons.history, 'সাম্প্রতিক পাঠ'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার লাইব্রেরি'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: deepGreen,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gold.withValues(alpha: 0.7),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: gold,
                    size: 42,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'আমার সংরক্ষিত বিষয়',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'আপনার প্রিয় ও সংরক্ষিত ইসলামিক বিষয়গুলো এক জায়গায়।',
                          style: TextStyle(
                            color: Color(0xFFE8D58A),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'লাইব্রেরি',
              style: TextStyle(
                color: deepGreen,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.45,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.title} — শীঘ্রই যুক্ত হবে',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: gold.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: green.withValues(alpha: 0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              color: green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: deepGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.subtitle,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryItem {
  final String title;
  final IconData icon;
  final String subtitle;

  const _LibraryItem(
    this.title,
    this.icon,
    this.subtitle,
  );
}
