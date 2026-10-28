import 'package:flutter/material.dart';

class HadithGradeInfoPage extends StatelessWidget {
  const HadithGradeInfoPage({super.key});

  static const _green = Color(0xFF087A3B);
  static const _deepGreen = Color(0xFF063B25);
  static const _gold = Color(0xFFC9A227);
  static const _cream = Color(0xFFFFFCF4);
  static const _softGreen = Color(0xFFEAF6F0);

  static const List<_GradeInfo> _grades = [
    _GradeInfo(
      number: '১',
      title: 'সহীহ লি-জাতিহী',
      english: 'Sahih li-dhatihi',
      description:
          'এটি ১ম গ্রেড বা সর্বোচ্চ মানের হাদিস। এর বর্ণনাকারীদের সততা ও স্মৃতিশক্তি নির্ভরযোগ্য এবং সনদের ধারাবাহিকতা পূর্ণাঙ্গ ও গ্রহণযোগ্য।',
    ),
    _GradeInfo(
      number: '২',
      title: 'সহীহ লি-গাইরিহী',
      english: 'Sahih li-ghayrihi',
      description:
          'এটি ২য় গ্রেড। মূলত হাসান স্তরের হাদিস হলেও অন্যান্য সনদ বা সমর্থনকারী বর্ণনার কারণে এর গ্রহণযোগ্যতা বৃদ্ধি পেয়ে সহীহের পর্যায়ে উন্নীত হয়।',
    ),
    _GradeInfo(
      number: '৩',
      title: 'হাসান লি-জাতিহী',
      english: 'Hasan li-dhatihi',
      description:
          'এটি ৩য় গ্রেড। বর্ণনাকারীরা গ্রহণযোগ্য ও সৎ হলেও তাদের স্মরণশক্তি সহীহ স্তরের বর্ণনাকারীদের তুলনায় কিছুটা কম হতে পারে।',
    ),
    _GradeInfo(
      number: '৪',
      title: 'হাসান লি-গাইরিহী',
      english: 'Hasan li-ghayrihi',
      description:
          'এটি ৪র্থ গ্রেড। মূলত সামান্য দুর্বল কোনো বর্ণনা অন্য সূত্র বা সমর্থনকারী প্রমাণের কারণে হাসান স্তরে উন্নীত হলে তাকে হাসান লি-গাইরিহী বলা হয়।',
    ),
    _GradeInfo(
      number: '৫',
      title: 'যঈফ',
      english: "Da'if",
      description:
          'এটি ৫ম গ্রেড বা দুর্বল হাদিস। সনদের কোনো দুর্বলতা, বর্ণনাকারীর স্মরণশক্তির সমস্যা বা অন্য কোনো গ্রহণযোগ্যতার ঘাটতির কারণে এর মান দুর্বল হতে পারে।',
    ),
    _GradeInfo(
      number: '৬',
      title: 'মাওদ্বূ / জাল',
      english: 'Mawdu / Fabricated',
      description:
          'এটি জাল বা মনগড়া বর্ণনা। রাসূলুল্লাহ ﷺ-এর নামে বানানো কথা হিসেবে প্রমাণিত হলে তাকে মাওদ্বূ বা জাল বলা হয়।',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'হাদিসের মান ও শ্রেণিবিন্যাস',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _deepGreen,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _gold.withValues(alpha: 0.75),
                width: 1.2,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'হাদিসের মান',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'হাদিসের গ্রহণযোগ্যতা ও শ্রেণিবিন্যাস বুঝতে নিচের সংক্ষিপ্ত তথ্যগুলো দেখুন।',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ..._grades.map(_buildGradeCard),
        ],
      ),
    );
  }

  Widget _buildGradeCard(_GradeInfo grade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _green.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
              border: Border.all(
                color: _gold,
                width: 1.3,
              ),
            ),
            child: Text(
              grade.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.title,
                  style: const TextStyle(
                    color: _deepGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  grade.english,
                  style: const TextStyle(
                    color: _green,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  grade.description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeInfo {
  final String number;
  final String title;
  final String english;
  final String description;

  const _GradeInfo({
    required this.number,
    required this.title,
    required this.english,
    required this.description,
  });
}
