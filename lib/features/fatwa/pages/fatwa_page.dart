import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FatwaPage extends StatelessWidget {
  const FatwaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ফতওয়া'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green.withValues(alpha: 0.10),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.55),
                ),
              ),
              child: const Icon(
                Icons.balance,
                size: 38,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ফতওয়া',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ইসলামী মাসআলা ও ফতওয়া',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
