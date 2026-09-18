import 'package:flutter/material.dart';

import '../models/accessibility_option.dart';

class AccessibilityOptionCard extends StatelessWidget {
  final AccessibilityOption option;
  final VoidCallback onTap;

  const AccessibilityOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.accessibility_new_rounded),
        ),
        title: Text(
          option.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(option.subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
