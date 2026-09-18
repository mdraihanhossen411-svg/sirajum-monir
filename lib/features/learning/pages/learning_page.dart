import 'package:flutter/material.dart';

import '../data/learning_data.dart';
import '../models/learning_topic.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'verified':
        return Icons.verified_outlined;
      case 'mosque':
        return Icons.mosque_outlined;
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'nightlight':
        return Icons.nightlight_round;
      case 'volunteer_activism':
        return Icons.volunteer_activism_outlined;
      case 'flight':
        return Icons.flight_takeoff_outlined;
      case 'auto_stories':
        return Icons.auto_stories_outlined;
      case 'library_books':
        return Icons.library_books_outlined;
      case 'favorite':
        return Icons.favorite_border;
      case 'self_improvement':
        return Icons.self_improvement_outlined;
      case 'family':
        return Icons.family_restroom;
      case 'child_care':
        return Icons.child_care_outlined;
      case 'question_answer':
        return Icons.question_answer_outlined;
      case 'menu_book':
      default:
        return Icons.menu_book_outlined;
    }
  }

  void _openCategory(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LearningTopicPage(categoryTitle: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = LearningData.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ইসলামিক শিক্ষা'),
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
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: gold,
                      size: 32,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ইসলামিক শিক্ষা',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'বিষয় নির্বাচন করুন এবং ধাপে ধাপে শিখুন',
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
            ...categories.map(
              (category) => Card(
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
                    _iconFor(category.iconName),
                    color: green,
                  ),
                  title: Text(
                    category.title,
                    style: const TextStyle(
                      color: deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: gold,
                  ),
                  onTap: () => _openCategory(
                    context,
                    category.title,
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

class LearningTopicPage extends StatelessWidget {
  const LearningTopicPage({
    super.key,
    required this.categoryTitle,
  });

  final String categoryTitle;

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    final topics = LearningData.topics[categoryTitle] ??
        const <LearningTopic>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];

            return Card(
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
                leading: CircleAvatar(
                  backgroundColor: green,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  topic.title,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningDetailPage(
                        categoryTitle: categoryTitle,
                        topic: topic,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class LearningDetailPage extends StatelessWidget {
  const LearningDetailPage({
    super.key,
    required this.categoryTitle,
    required this.topic,
  });

  final String categoryTitle;
  final LearningTopic topic;

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
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
            child: ListView(
              children: [
                Text(
                  categoryTitle,
                  style: const TextStyle(
                    color: green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: deepGreen,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(color: gold),
                const SizedBox(height: 18),
                const Center(
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 60,
                    color: green,
                  ),
                ),
                const SizedBox(height: 18),
                if (topic.introduction.isNotEmpty) ...[
                  Text(
                    topic.introduction,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (topic.mainLesson.isNotEmpty) ...[
                  const Text(
                    'মূল শিক্ষা',
                    style: TextStyle(
                      color: green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic.mainLesson,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (topic.content.isNotEmpty) ...[
                  Text(
                    topic.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (topic.references.isNotEmpty) ...[
                  const Text(
                    'রেফারেন্স',
                    style: TextStyle(
                      color: green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...topic.references.map(
                    (reference) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• $reference',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
                if (topic.introduction.isEmpty &&
                    topic.mainLesson.isEmpty &&
                    topic.content.isEmpty) ...[
                  const Text(
                    'এই বিষয়ের যাচাই করা ইসলামিক কনটেন্ট পরবর্তীতে এখানে যুক্ত করা হবে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
