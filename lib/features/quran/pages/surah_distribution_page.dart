import 'package:flutter/material.dart';
import '../models/quran_model.dart';

class SurahDistributionPage extends StatelessWidget {
  final SurahModel surah;

  const SurahDistributionPage({
    super.key,
    required this.surah,
  });

  String _banglaAyah(int number) {
    const digits = '০১২৩৪৫৬৭৮৯';
    return number
        .toString()
        .split('')
        .map((e) => digits[int.parse(e)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final revelationType = switch (surah.revelationType.trim()) {
      'মাক্কী' => 'মাক্কী',
      'মাদানী' => 'মাদানী',
      _ => 'তথ্য নেই',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('সূরা বিস্তারিত'),
        backgroundColor: const Color(0xFF0A8754),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 30),
        children: [
          _section(
            context,
            icon: Icons.menu_book_rounded,
            title: 'নাম',
            child: Text(
              '${surah.banglaName} — ${surah.englishName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _section(
            context,
            icon: Icons.format_list_numbered_rounded,
            title: 'আয়াত',
            child: Text(
              '${_banglaAyah(surah.totalAyah)}টি',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          _section(
            context,
            icon: Icons.location_on_outlined,
            title: 'নাজিলের স্থান',
            child: Text(
              revelationType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _section(
            context,
            icon: Icons.format_list_numbered_rounded,
            title: 'অবস্থান',
            child: Text(
              'কুরআনে সূরা ${_banglaAyah(surah.id)} নম্বরে',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          _section(
            context,
            icon: Icons.auto_awesome_outlined,
            title: 'অন্যান্য নাম',
            child: Text(
              surah.id == 1
                  ? 'উম্মুল কুরআন, উম্মুল কিতাব, সাবআ মাছানী'
                  : 'প্রচলিত অন্যান্য নামের তথ্য শীঘ্রই যুক্ত হবে।',
              style: const TextStyle(
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
          _section(
            context,
            icon: Icons.history_edu_outlined,
            title: 'শানে নূরুল / মূল প্রেক্ষাপট বা ঘটনা',
            child: Text(
              surah.id == 1
                  ? 'সূরা আল-ফাতিহা কুরআন মাজীদের সূচনা করেছে এবং নামাজের প্রতিটি রাকাতে পাঠ করা হয়। এতে আল্লাহ তাআলার প্রশংসা, তাঁর রহমত ও মালিকানার স্বীকৃতি, একমাত্র তাঁরই ইবাদত ও সাহায্য প্রার্থনা এবং সরল পথের দোয়া একত্রিত হয়েছে। এজন্য এটি মুসলিম জীবনে অত্যন্ত গুরুত্বপূর্ণ একটি সূরা।'
                  : 'এই সূরার শানে নূরুল ও মূল প্রেক্ষাপটের বিস্তারিত তথ্য শীঘ্রই যুক্ত হবে।',
              style: const TextStyle(
                fontSize: 17,
                height: 1.85,
              ),
            ),
          ),
          _section(
            context,
            icon: Icons.star_border_rounded,
            title: 'ফজিলত ও গুরুত্ব',
            child: surah.id == 1
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Point(
                        number: '১',
                        text: 'নামাজের গুরুত্বপূর্ণ অংশ হিসেবে সূরা আল-ফাতিহার বিশেষ মর্যাদা রয়েছে।',
                      ),
                      _Point(
                        number: '২',
                        text: 'এতে বান্দা আল্লাহ তাআলার প্রশংসা ও তাঁর কাছে সরাসরি দোয়া করে।',
                      ),
                      _Point(
                        number: '৩',
                        text: 'রুকইয়াহ ও শিফার ক্ষেত্রে সূরা আল-ফাতিহার বিশেষ ফজিলত বর্ণিত হয়েছে।',
                      ),
                      _Point(
                        number: '৪',
                        text: 'এটি হেদায়াতের আলো ও আল্লাহর রহমত প্রার্থনার অন্যতম শ্রেষ্ঠ মাধ্যম।',
                      ),
                      _Point(
                        number: '৫',
                        text: 'বান্দার দোয়া ও আল্লাহর প্রতি পূর্ণ নির্ভরতার শিক্ষা এতে রয়েছে।',
                      ),
                    ],
                  )
                : const Text(
                    'এই সূরার ফজিলত ও গুরুত্বের বিস্তারিত তথ্য শীঘ্রই যুক্ত হবে।',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.8,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final green = theme.colorScheme.primary;
    final gold = theme.colorScheme.secondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: green.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: green, size: 23),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            child,
          ],
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  final String number;
  final String text;

  const _Point({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
