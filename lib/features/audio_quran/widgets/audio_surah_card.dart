import 'package:flutter/material.dart';

import '../models/audio_surah_model.dart';

class AudioSurahCard extends StatelessWidget {
  final AudioSurahModel surah;
  final VoidCallback onTap;

  const AudioSurahCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  static const green = Color(0xFF087A3B);
  static const gold = Color(0xFFC9A227);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: gold.withValues(alpha: 0.30),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        leading: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: green.withValues(alpha: 0.09),
            border: Border.all(
              color: gold.withValues(alpha: 0.55),
            ),
          ),
          child: Text(
            '${surah.number}',
            style: const TextStyle(
              color: green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          surah.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('${surah.ayahCount} আয়াত'),
        trailing: const Icon(
          Icons.play_circle_fill,
          color: green,
          size: 36,
        ),
        onTap: onTap,
      ),
    );
  }
}
