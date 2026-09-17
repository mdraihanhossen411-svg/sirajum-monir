import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FamilyBackupService {
  Future<String> createBackup() async {
    final prefs = await SharedPreferences.getInstance();

    final backup = <String, dynamic>{
      'version': 1,
      'members': _decode(prefs.getString('family_members')),
      'events': _decode(prefs.getString('family_events')),
      'activity': _decode(prefs.getString('family_activity')),
      'notifications': {
        'prayer': prefs.getBool('family_notification_prayer') ?? true,
        'quran': prefs.getBool('family_notification_quran') ?? true,
        'duaDhikr':
            prefs.getBool('family_notification_dua_dhikr') ?? true,
        'learning':
            prefs.getBool('family_notification_learning') ?? false,
        'familyEvents':
            prefs.getBool('family_notification_events') ?? true,
      },
    };

    return jsonEncode(backup);
  }

  Future<bool> restoreBackup(String raw) async {
    try {
      final data = jsonDecode(raw);

      if (data is! Map) return false;

      final prefs = await SharedPreferences.getInstance();

      if (data['members'] is List) {
        await prefs.setString(
          'family_members',
          jsonEncode(data['members']),
        );
      }

      if (data['events'] is List) {
        await prefs.setString(
          'family_events',
          jsonEncode(data['events']),
        );
      }

      if (data['activity'] is Map) {
        await prefs.setString(
          'family_activity',
          jsonEncode(data['activity']),
        );
      }

      final notifications = data['notifications'];

      if (notifications is Map) {
        await prefs.setBool(
          'family_notification_prayer',
          notifications['prayer'] == true,
        );
        await prefs.setBool(
          'family_notification_quran',
          notifications['quran'] == true,
        );
        await prefs.setBool(
          'family_notification_dua_dhikr',
          notifications['duaDhikr'] == true,
        );
        await prefs.setBool(
          'family_notification_learning',
          notifications['learning'] == true,
        );
        await prefs.setBool(
          'family_notification_events',
          notifications['familyEvents'] == true,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  dynamic _decode(String? raw) {
    if (raw == null || raw.isEmpty) return [];

    try {
      return jsonDecode(raw);
    } catch (_) {
      return [];
    }
  }
}
