import 'package:flutter/material.dart';

class MosquePage extends StatelessWidget {
  const MosquePage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🕌 মসজিদ'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: deepGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mosque,
                      color: gold,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'আপনার কাছাকাছি মসজিদ খুঁজুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'নিকটবর্তী মসজিদ খুঁজে পেতে বর্তমান অবস্থান ব্যবহার করুন।',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showMessage(
                      context,
                      'বর্তমান অবস্থান সুবিধা শীঘ্রই যুক্ত হবে।',
                    );
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('বর্তমান অবস্থান ব্যবহার করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'মসজিদ খুঁজুন',
                style: TextStyle(
                  color: deepGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                onSubmitted: (_) {
                  _showMessage(
                    context,
                    'মসজিদ অনুসন্ধান সুবিধা শীঘ্রই যুক্ত হবে।',
                  );
                },
                decoration: InputDecoration(
                  hintText: 'মসজিদের নাম বা এলাকার নাম লিখুন...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'কাছাকাছি মসজিদ',
                style: TextStyle(
                  color: deepGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _MosquePlaceholderCard(
                icon: Icons.location_city,
                title: 'মসজিদের তালিকা',
                subtitle: 'অবস্থান চালু করলে কাছাকাছি মসজিদ এখানে দেখা যাবে।',
              ),

              const SizedBox(height: 12),

              _MosquePlaceholderCard(
                icon: Icons.map,
                title: 'মসজিদের বিস্তারিত',
                subtitle: 'ঠিকানা, দূরত্ব, দিকনির্দেশনা ও অন্যান্য তথ্য এখানে থাকবে।',
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.65),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: green,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'পরবর্তী ধাপে আসল মসজিদ অনুসন্ধান, দূরত্ব ও দিকনির্দেশনা যুক্ত করা হবে।',
                        style: TextStyle(
                          color: deepGreen,
                          fontSize: 14,
                          height: 1.5,
                        ),
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
  }
}

class _MosquePlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MosquePlaceholderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: MosquePage.gold.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: MosquePage.green.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: MosquePage.green,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: MosquePage.deepGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
