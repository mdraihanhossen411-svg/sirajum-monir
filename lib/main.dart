import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/notifications/notification_service.dart';
import 'features/prayer/controllers/prayer_notification_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SirajumMonirApp());

  // UI শুরু হওয়ার পরে notification system চালু হবে।
  // এতে Splash/Welcome দেখানোর আগে ভারী initialization আটকে থাকবে না।
  Future<void>(() async {
    final notificationService = NotificationService.instance;

    await notificationService.initialize();
    await notificationService.scheduleUpcomingAyahNotifications(
      days: 30,
    );

    final prayerNotificationController =
        PrayerNotificationController();

    if (await prayerNotificationController.isEnabled()) {
      await notificationService.schedulePrayerNotifications(
        days: 7,
        enabledPrayers:
            await prayerNotificationController
                .getEnabledPrayers(),
      );
    }
  });
}
