import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FamilyStorageService {
  static const String _membersKey = 'family_members';
  static const String _eventsKey = 'family_events';
  static const String _notificationsKey = 'family_notifications';

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> loadMembers() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_membersKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMembers(
    List<Map<String, dynamic>> members,
  ) async {
    final prefs = await _prefs;
    await prefs.setString(
      _membersKey,
      jsonEncode(members),
    );
  }

  Future<List<Map<String, dynamic>>> loadEvents() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_eventsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveEvents(
    List<Map<String, dynamic>> events,
  ) async {
    final prefs = await _prefs;
    await prefs.setString(
      _eventsKey,
      jsonEncode(events),
    );
  }

  Future<Map<String, bool>> loadNotificationSettings() async {
    final prefs = await _prefs;

    return {
      'prayer': prefs.getBool('family_notification_prayer') ?? true,
      'quran': prefs.getBool('family_notification_quran') ?? true,
      'duaDhikr': prefs.getBool('family_notification_dua_dhikr') ?? true,
      'learning': prefs.getBool('family_notification_learning') ?? false,
      'familyEvents':
          prefs.getBool('family_notification_events') ?? true,
    };
  }

  Future<void> saveNotificationSettings(
    Map<String, bool> settings,
  ) async {
    final prefs = await _prefs;

    await prefs.setBool(
      'family_notification_prayer',
      settings['prayer'] ?? true,
    );
    await prefs.setBool(
      'family_notification_quran',
      settings['quran'] ?? true,
    );
    await prefs.setBool(
      'family_notification_dua_dhikr',
      settings['duaDhikr'] ?? true,
    );
    await prefs.setBool(
      'family_notification_learning',
      settings['learning'] ?? false,
    );
    await prefs.setBool(
      'family_notification_events',
      settings['familyEvents'] ?? true,
    );
  }

  Future<void> clearFamilyData() async {
    final prefs = await _prefs;

    await prefs.remove(_membersKey);
    await prefs.remove(_eventsKey);
    await prefs.remove(_notificationsKey);

    await prefs.remove('family_notification_prayer');
    await prefs.remove('family_notification_quran');
    await prefs.remove('family_notification_dua_dhikr');
    await prefs.remove('family_notification_learning');
    await prefs.remove('family_notification_events');
  }
}
