import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  static const categories = <Map<String, dynamic>>[
    {
      'title': 'কুরআন শরীফ ও তাফসির',
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'হাদিস শরীফ',
      'icon': Icons.library_books_rounded,
    },
    {
      'title': 'ফিকহ বা ফতওয়া',
      'icon': Icons.gavel_rounded,
    },
    {
      'title': 'ইলমে তাছাউফ',
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'title': 'নবী ও রাসূল ﷺ উনাদের জীবনী',
      'icon': Icons.mosque_rounded,
    },
    {
      'title': 'সাহাবায়ে কেরাম রাঃ উনাদের জীবনী',
      'icon': Icons.people_alt_rounded,
    },
    {
      'title': 'আওলায়ে কেরাম রহঃ উনাদের জীবনী',
      'icon': Icons.star_rounded,
    },
    {
      'title': 'ইসলামিক ইতিহাস',
      'icon': Icons.account_balance_rounded,
    },
    {
      'title': 'অন্যান্য',
      'icon': Icons.auto_stories_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ইসলামী কিতাব'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'কিতাব খুঁজুন',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: categories.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  elevation: 0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(
                        category['icon'] as IconData,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      category['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${category['title']} — শীঘ্রই আসছে',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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
