import 'package:flutter/foundation.dart';
import 'package:adhan/adhan.dart';

class AdhanService {
  static final AdhanService _instance = AdhanService._internal();

  factory AdhanService() => _instance;

  AdhanService._internal();

  final Coordinates coordinates = Coordinates(
    23.9088,
    89.1220,
  );

  PrayerTimes getTodayPrayerTimes() {
    final params = CalculationMethod.karachi.getParameters();

    // বাংলাদেশে Hanafi পদ্ধতি
    params.madhab = Madhab.hanafi;

    final date = DateComponents.from(DateTime.now());

    return PrayerTimes(
      coordinates,
      date,
      params,
      utcOffset: const Duration(hours: 6),
    );
  }

  void printPrayerTimes() {
    final times = getTodayPrayerTimes();

    debugPrint('ফজর: ${times.fajr}');
    debugPrint('সূর্যোদয়: ${times.sunrise}');
    debugPrint('যোহর: ${times.dhuhr}');
    debugPrint('আসর: ${times.asr}');
    debugPrint('মাগরিব: ${times.maghrib}');
    debugPrint('এশা: ${times.isha}');
  }
}