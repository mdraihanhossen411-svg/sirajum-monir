import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/audio_surah_model.dart';

class AudioSurahData {
  static Future<List<AudioSurahModel>> load() async {
    final manifestText =
        await rootBundle.loadString('AssetManifest.json');

    final manifest =
        jsonDecode(manifestText) as Map<String, dynamic>;

    final paths = manifest.keys
        .where(
          (path) =>
              path.startsWith('assets/json/quran/core/surah_') &&
              path.endsWith('.json'),
        )
        .toList()
      ..sort((a, b) {
        final aNumber = _number(a);
        final bNumber = _number(b);
        return aNumber.compareTo(bNumber);
      });

    final result = <AudioSurahModel>[];

    for (final path in paths) {
      final number = _number(path);

      final jsonText = await rootBundle.loadString(path);
      final data = jsonDecode(jsonText) as Map<String, dynamic>;

      final ayahs =
          data['ayahs'] as List<dynamic>? ?? const [];

      result.add(
        AudioSurahModel(
          number: number,
          name: (data['banglaName'] ?? data['bangla_name'] ?? '')
              .toString(),
          arabicName: (data['arabicName'] ?? '').toString(),
          ayahCount:
              (data['totalAyah'] as num?)?.toInt() ??
              ayahs.length,
        ),
      );
    }

    return result;
  }

  static int _number(String path) {
    final match =
        RegExp(r'surah_(\d+)\.json$').firstMatch(path);

    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }
}
