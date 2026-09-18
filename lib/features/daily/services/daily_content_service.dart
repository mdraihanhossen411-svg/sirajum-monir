import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/daily_content_model.dart';

class DailyContentService {
  static const String _dailyAssetPath =
      'assets/json/daily/daily_content.json';

  Future<Map<String, dynamic>> _loadData() async {
    final jsonString = await rootBundle.loadString(_dailyAssetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _loadSurah(int surahNumber) async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/core/surah_$surahNumber.json',
    );

    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<String> getAyahBanglaText({
    required int surahNumber,
    required String ayahNumber,
  }) async {
    final surah = await _loadSurah(surahNumber);

    final ayahs = List<Map<String, dynamic>>.from(
      (surah['ayahs'] as List).map(
        (item) => Map<String, dynamic>.from(item),
      ),
    );

    final parts = ayahNumber.split('-');

    final start = int.tryParse(parts.first.trim());

    if (start == null) {
      return '';
    }

    final end = parts.length > 1
        ? int.tryParse(parts.last.trim()) ?? start
        : start;

    final selected = ayahs.where((ayah) {
      final number = ayah['number'] as int? ?? 0;
      return number >= start && number <= end;
    }).toList();

    return selected
        .map((ayah) => (ayah['banglaText'] ?? '').toString().trim())
        .where((text) => text.isNotEmpty)
        .join(' ');
  }

  Future<Map<String, dynamic>?> getForDay(int dayOfYear) async {
    final data = await _loadData();

    final item = data[dayOfYear.toString()];

    if (item == null) {
      return null;
    }

    return Map<String, dynamic>.from(item);
  }

  Future<DailyContent?> getForDate(DateTime date) async {
    final data = await _loadData();

    final dayOfYear =
        date.difference(DateTime(date.year, 1, 1)).inDays + 1;

    final item = data[dayOfYear.toString()];

    if (item == null) {
      return null;
    }

    return DailyContent.fromJson(
      Map<String, dynamic>.from(item),
    );
  }

  Future<DailyContent?> getToday() async {
    final now = tz.TZDateTime.now(tz.local);
    return getForDate(now);
  }
}
