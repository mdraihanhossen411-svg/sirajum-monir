import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';

class PrayerNotificationController {
  static const String _enabledKey =
      'prayer_notifications_enabled';

  static const Map<int, String> prayerKeys = {
    1: 'prayer_notification_fajr',
    2: 'prayer_notification_dhuhr',
    3: 'prayer_notification_asr',
    4: 'prayer_notification_maghrib',
    5: 'prayer_notification_isha',
  };

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_enabledKey) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_enabledKey, enabled);

    if (enabled) {
      await NotificationService.instance
          .schedulePrayerNotifications(
        days: 7,
        enabledPrayers: await getEnabledPrayers(),
      );
    } else {
      await NotificationService.instance
          .cancelPrayerNotifications(
        days: 14,
      );
    }
  }

  Future<bool> isPrayerEnabled(int prayerType) async {
    final prefs = await SharedPreferences.getInstance();

    final key = prayerKeys[prayerType];

    if (key == null) {
      return true;
    }

    return prefs.getBool(key) ?? true;
  }

  Future<void> setPrayerEnabled(
    int prayerType,
    bool enabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final key = prayerKeys[prayerType];

    if (key == null) {
      return;
    }

    await prefs.setBool(key, enabled);

    final mainEnabled = await isEnabled();

    if (!mainEnabled) {
      return;
    }

    await NotificationService.instance
        .schedulePrayerNotifications(
      days: 7,
      enabledPrayers: await getEnabledPrayers(),
    );
  }

  Future<List<int>> getEnabledPrayers() async {
    final result = <int>[];

    for (final prayerType in prayerKeys.keys) {
      if (await isPrayerEnabled(prayerType)) {
        result.add(prayerType);
      }
    }

    return result;
  }
}
