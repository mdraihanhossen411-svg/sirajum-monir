import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class IslamicSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const IslamicSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.55),
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: 42,
          height: 1,
          color: AppColors.gold.withValues(alpha: 0.55),
        ),
      ],
    );
  }
}
