import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  static const sections = <Map<String, dynamic>>[
    {'title': 'কুরআন', 'icon': Icons.menu_book_outlined},
    {'title': 'হাদিস', 'icon': Icons.library_books_outlined},
    {'title': 'দোয়া ও যিকির', 'icon': Icons.favorite_border},
    {'title': 'নামাজ ও আমল', 'icon': Icons.mosque_outlined},
    {'title': 'তাসবিহ', 'icon': Icons.circle_outlined},
    {'title': 'আমার লাইব্রেরী', 'icon': Icons.bookmark_border},
    {'title': 'পরিবার', 'icon': Icons.family_restroom},
    {'title': 'ইসলামিক ক্যালেন্ডার', 'icon': Icons.calendar_month_outlined},
    {'title': 'রমজান', 'icon': Icons.nightlight_round},
    {'title': 'নোটিফিকেশন', 'icon': Icons.notifications_none},
  ];

  void _openSection(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardSectionPage(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ড্যাশবোর্ড'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          children: [
            Card(
              elevation: 0,
              color: deepGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      color: gold,
                      size: 34,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'আজকের সারাংশ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'আপনার ইসলামিক কার্যক্রমের সারসংক্ষেপ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            const _OverallProgressCard(),

            const SizedBox(height: 18),

            const Text(
              'ফিচারভিত্তিক অগ্রগতি',
              style: TextStyle(
                color: deepGreen,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            ...sections.map(
              (section) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(
                    color: gold,
                    width: 0.7,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    section['icon'] as IconData,
                    color: green,
                  ),
                  title: Text(
                    section['title'] as String,
                    style: const TextStyle(
                      color: deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: gold,
                  ),
                  onTap: () => _openSection(
                    context,
                    section['title'] as String,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard();

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: gold,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'সামগ্রিক অগ্রগতি',
              style: TextStyle(
                color: deepGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            const LinearProgressIndicator(
              value: 0,
              minHeight: 9,
              backgroundColor: Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(green),
            ),
            const SizedBox(height: 10),
            Text(
              'ডেটা যুক্ত হলে অগ্রগতি এখানে দেখাবে',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardSectionPage extends StatelessWidget {
  const DashboardSectionPage({
    super.key,
    required this.title,
  });

  final String title;

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: gold,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  color: green,
                  size: 52,
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    color: deepGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: gold),
                const SizedBox(height: 16),
                const Text(
                  'এই অংশের প্রকৃত ডেটা ও বিস্তারিত কার্যকারিতা '
                  'পরবর্তী Data Phase-এ যুক্ত করা হবে।',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
