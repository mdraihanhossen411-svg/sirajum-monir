import 'package:flutter/material.dart';

import '../data/accessibility_data.dart';
import '../widgets/accessibility_option_card.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  void _openOption(
    BuildContext context,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AccessibilityDetailPage(
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('অ্যাক্সেসিবিলিটি'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.accessibility_new_rounded,
                    size: 52,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'সহজ ও আরামদায়ক ব্যবহার',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'অ্যাপটি বিভিন্ন ব্যবহারকারীর প্রয়োজন অনুযায়ী সহজে ব্যবহার করার জন্য Accessibility সুবিধাগুলো এখানে সাজানো থাকবে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Accessibility Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (final option in AccessibilityData.options)
            AccessibilityOptionCard(
              option: option,
              onTap: () => _openOption(
                context,
                option.title,
              ),
            ),
        ],
      ),
    );
  }
}

class _AccessibilityDetailPage extends StatelessWidget {
  final String title;

  const _AccessibilityDetailPage({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.accessibility_new_rounded,
                    size: 52,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'এই সুবিধার প্রকৃত functionality পরবর্তী Data & Functionality Phase-এ যুক্ত হবে।',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
