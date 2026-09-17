import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FamilyActivityService {
  static const String _key = 'family_activity';

  Future<Map<String, int>> loadToday() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) {
      return _defaults();
    }

    try {
      final data = jsonDecode(raw);
      if (data is Map) {
        return {
          'salah': (data['salah'] as num?)?.toInt() ?? 0,
          'quran': (data['quran'] as num?)?.toInt() ?? 0,
          'duaDhikr': (data['duaDhikr'] as num?)?.toInt() ?? 0,
          'learning': (data['learning'] as num?)?.toInt() ?? 0,
        };
      }
    } catch (_) {}

    return _defaults();
  }

  Future<void> saveToday(Map<String, int> activity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(activity));
  }

  Future<void> setActivity(String key, int value) async {
    final data = await loadToday();
    data[key] = value.clamp(0, 100);
    await saveToday(data);
  }

  Map<String, int> _defaults() => {
        'salah': 0,
        'quran': 0,
        'duaDhikr': 0,
        'learning': 0,
      };
}
