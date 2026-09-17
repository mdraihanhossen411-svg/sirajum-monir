import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/daily/services/daily_content_service.dart';
import '../../features/prayer/controllers/prayer_controller.dart';
import '../../features/prayer/services/adhan_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final DailyContentService _dailyContentService =
      DailyContentService();

  static const String _dailyChannelId = 'daily_islamic_content';
  static const String _dailyChannelName = 'দৈনিক ইসলামিক নোটিফিকেশন';
  static const String _dailyChannelDescription =
      'আয়াত, হাদিস, দোয়া ও আমলের দৈনিক নোটিফিকেশন';

  static const String _prayerChannelId = 'prayer_times';
  static const String _prayerChannelName = 'নামাজের সময়';
  static const String _prayerChannelDescription =
      'পাঁচ ওয়াক্ত নামাজের সময়ের নোটিফিকেশন';

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(
      settings: settings,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          _dailyChannelName,
          channelDescription: _dailyChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleUpcomingAyahNotifications({
    int days = 30,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    for (int offset = 0; offset < days; offset++) {
      final date = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + offset,
      );

      final content =
          await _dailyContentService.getForDate(date);

      if (content == null) {
        continue;
      }

      final ayahText =
          await _dailyContentService.getAyahBanglaText(
        surahNumber: content.ayah.surahNumber,
        ayahNumber: content.ayah.ayahNumber,
      );

      if (ayahText.trim().isEmpty) {
        continue;
      }

      await scheduleDaily(
        id: _notificationId(date, 1),
        title: '📖 আজকের আয়াত',
        body: '$ayahText\n${content.ayah.source}',
        date: date,
        hour: 6,
        minute: 0,
      );
    }
  }

  Future<void> scheduleTodayContent() async {
    final now = tz.TZDateTime.now(tz.local);

    final content =
        await _dailyContentService.getToday();

    if (content == null) {
      return;
    }

    final ayahText =
        await _dailyContentService.getAyahBanglaText(
      surahNumber: content.ayah.surahNumber,
      ayahNumber: content.ayah.ayahNumber,
    );

    if (ayahText.isNotEmpty) {
      final ayahBody =
          '$ayahText\n${content.ayah.source}';

      await scheduleDaily(
        id: _notificationId(now, 1),
        title: '📖 আজকের আয়াত',
        body: ayahBody,
        date: now,
        hour: 6,
        minute: 0,
      );
    }

    if (content.hadith.source.trim().isNotEmpty) {
      await scheduleDaily(
        id: _notificationId(now, 2),
        title: '📜 আজকের হাদিস',
        body: content.hadith.source,
        date: now,
        hour: 9,
        minute: 0,
      );
    }

    if (content.dua.source.trim().isNotEmpty) {
      await scheduleDaily(
        id: _notificationId(now, 3),
        title: '🤲 আজকের দোয়া',
        body: content.dua.source,
        date: now,
        hour: 12,
        minute: 0,
      );
    }

    if (content.amal.source.trim().isNotEmpty) {
      await scheduleDaily(
        id: _notificationId(now, 4),
        title: '🌙 আজকের আমল',
        body: content.amal.source,
        date: now,
        hour: 15,
        minute: 0,
      );
    }
  }

  /// আগামী কয়েক দিনের পাঁচ ওয়াক্ত নামাজের notification schedule করে।
  ///
  /// Prayer notification-এর ID 11-15 type ব্যবহার করে,
  /// তাই Daily notification-এর ID 1-4-এর সঙ্গে সংঘর্ষ হবে না।
  Future<void> schedulePrayerNotifications({
    int days = 7,
    bool useGps = false,
    List<int>? enabledPrayers,
  }) async {
    // আগের Prayer notifications সরিয়ে নতুন location/time অনুযায়ী
    // আবার schedule করা হবে।
    await cancelPrayerNotifications(days: 14);

    final prayerController = PrayerController();

    final activePrayers =
        enabledPrayers ?? const [1, 2, 3, 4, 5];

    // প্রথমে আজকের location resolve করি.
    // GPS সফল হলে AdhanService-এ GPS coordinates বসবে।
    // GPS ব্যর্থ হলে saved district ব্যবহার হবে।
    await prayerController.getTodayPrayerTimes(
      useGps: useGps,
    );

    final adhanService = AdhanService();

    final now = tz.TZDateTime.now(tz.local);

    for (int offset = 0; offset < days; offset++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day + offset,
      );

      final prayerTimes =
          adhanService.getPrayerTimes(date);

      final prayers = [
        prayerTimes.fajr,
        prayerTimes.dhuhr,
        prayerTimes.asr,
        prayerTimes.maghrib,
        prayerTimes.isha,
      ];

      for (int index = 0; index < prayers.length; index++) {
        final prayerType = index + 1;

        if (!activePrayers.contains(prayerType)) {
          continue;
        }

        final prayer = prayers[index];

        final scheduledDate = tz.TZDateTime(
          tz.local,
          prayer.time.year,
          prayer.time.month,
          prayer.time.day,
          prayer.time.hour,
          prayer.time.minute,
          prayer.time.second,
        );

        if (!scheduledDate.isAfter(
          tz.TZDateTime.now(tz.local),
        )) {
          continue;
        }

        await _plugin.zonedSchedule(
          id: _prayerNotificationId(date, index + 1),
          title: '🕌 ${prayer.name} নামাজের সময়',
          body:
              '${prayer.name} নামাজের সময় হয়েছে।\n'
              'আল্লাহর স্মরণে নামাজ আদায় করুন।',
          scheduledDate: scheduledDate,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              _prayerChannelId,
              _prayerChannelName,
              channelDescription:
                  _prayerChannelDescription,
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode:
              AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> cancelPrayerNotifications({
    int days = 14,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    for (int offset = -1; offset < days; offset++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day + offset,
      );

      for (int prayerType = 1;
          prayerType <= 5;
          prayerType++) {
        await _plugin.cancel(id: 
          _prayerNotificationId(date, prayerType),
        );
      }
    }
  }

  int _prayerNotificationId(
    DateTime date,
    int prayerType,
  ) {
    final dayOfYear =
        date.difference(
              DateTime(date.year, 1, 1),
            ).inDays +
            1;

    return (date.year * 100000) +
        (dayOfYear * 100) +
        10 +
        prayerType;
  }

  int _notificationId(
    DateTime date,
    int type,
  ) {
    final dayOfYear =
        date.difference(
              DateTime(date.year, 1, 1),
            ).inDays +
            1;

    return (date.year * 10000) +
        (dayOfYear * 10) +
        type;
  }
}
