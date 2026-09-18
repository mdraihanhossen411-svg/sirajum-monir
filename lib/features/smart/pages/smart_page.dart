import 'package:flutter/material.dart';

class SmartPage extends StatelessWidget {
  const SmartPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  static const tools = <Map<String, dynamic>>[
    {'title': 'ইসলামিক প্রশ্ন অনুসন্ধান', 'icon': Icons.search_outlined},
    {'title': 'কুরআন থেকে খোঁজা', 'icon': Icons.auto_stories_outlined},
    {'title': 'হাদিস থেকে খোঁজা', 'icon': Icons.library_books_outlined},
    {'title': 'দোয়া খোঁজা', 'icon': Icons.favorite_border},
    {'title': 'ইসলামিক শিক্ষা সহায়ক', 'icon': Icons.school_outlined},
    {'title': 'নামাজ ও আমল সহায়ক', 'icon': Icons.mosque_outlined},
    {'title': 'ইসলামিক দিন ও তারিখ', 'icon': Icons.calendar_month_outlined},
    {'title': 'দৈনন্দিন ইসলামিক সহায়তা', 'icon': Icons.lightbulb_outline},
    {'title': 'ব্যক্তিগত নোট', 'icon': Icons.note_alt_outlined},
    {'title': 'সংরক্ষিত ফলাফল', 'icon': Icons.bookmark_border},
    {'title': 'Smart Islamic Settings', 'icon': Icons.settings_outlined},
  ];

  void _openTool(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SmartToolPage(toolTitle: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Islamic'),
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
                      Icons.auto_awesome,
                      color: gold,
                      size: 34,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Smart Islamic',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'ইসলামিক তথ্য ও সহায়তার জন্য স্মার্ট টুলসমূহ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...tools.map(
              (tool) => Card(
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
                    tool['icon'] as IconData,
                    color: green,
                  ),
                  title: Text(
                    tool['title'] as String,
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
                  onTap: () => _openTool(
                    context,
                    tool['title'] as String,
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

class SmartToolPage extends StatelessWidget {
  const SmartToolPage({
    super.key,
    required this.toolTitle,
  });

  final String toolTitle;

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toolTitle),
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
                  Icons.auto_awesome,
                  color: green,
                  size: 52,
                ),
                const SizedBox(height: 14),
                Text(
                  toolTitle,
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
                  'এই Smart Islamic সুবিধার কাঠামো প্রস্তুত। '
                  'যাচাইযোগ্য ইসলামিক উৎস ও প্রয়োজনীয় functionality '
                  'পরবর্তী ধাপে যুক্ত করা হবে।',
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
