import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/fatwa_model.dart';

class FatwaCard extends StatelessWidget {
  final FatwaModel fatwa;

  const FatwaCard({
    super.key,
    required this.fatwa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.balance,
          color: AppColors.green,
        ),
        title: Text(fatwa.question),
        subtitle: Text(fatwa.source),
      ),
    );
  }
}
