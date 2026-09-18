import 'dart:math';

import 'package:adhan/adhan.dart';

import '../models/prayer_models.dart';

class AdhanService {
  static final AdhanService _instance = AdhanService._internal();

  factory AdhanService() => _instance;

  AdhanService._internal();

  Coordinates _coordinates = Coordinates(
    23.8103,
    90.4125,
  );

  void setLocation({
    required double latitude,
    required double longitude,
  }) {
    _coordinates = Coordinates(latitude, longitude);
  }

  Coordinates get coordinates => _coordinates;

  PrayerTimes _getAdhanTimes(DateTime date) {
    final params = CalculationMethod.karachi.getParameters();

    // Bangladesh / South Asia:
    // Fajr 18°, Isha 18°, Hanafi Asr.
    params.madhab = Madhab.hanafi;

    return PrayerTimes(
      _coordinates,
      DateComponents.from(date),
      params,
      utcOffset: const Duration(hours: 6),
    );
  }

  DateTime _localTime(DateTime date, double decimalHour) {
    final base = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final totalMinutes = (decimalHour * 60).round();

    return base.add(Duration(minutes: totalMinutes));
  }

  double _solarNoonHour(DateTime date) {
    final dayOfYear =
        date.difference(DateTime(date.year, 1, 1)).inDays + 1;

    final gamma =
        (2 * pi / 365) * (dayOfYear - 1);

    final equationOfTime =
        229.18 *
        (0.000075 +
            0.001868 * cos(gamma) -
            0.032077 * sin(gamma) -
            0.014615 * cos(2 * gamma) -
            0.040849 * sin(2 * gamma));

    // Bangladesh is UTC+6.
    // Local solar noon = 12:00 - longitude/15 - EoT/60 + 6.
    return 18 -
        (_coordinates.longitude / 15) -
        (equationOfTime / 60);
  }

  PrayerDayTimes getPrayerTimes(DateTime date) {
    final times = _getAdhanTimes(date);

    final fajr = times.fajr;
    final sunrise = times.sunrise;
    final dhuhr = times.dhuhr;
    final asr = times.asr;
    final maghrib = times.maghrib;
    final isha = times.isha;

    final solarNoon = _localTime(
      date,
      _solarNoonHour(date),
    );

    final nextDay = date.add(const Duration(days: 1));
    final nextDayFajr = _getAdhanTimes(nextDay).fajr;

    // The prayer window ends when the next prayer begins.
    final fajrEnd = sunrise;
    final dhuhrEnd = asr;
    final asrEnd = maghrib;
    final maghribEnd = isha;
    final ishaEnd = nextDayFajr;

    // Practical Hanafi prohibited periods:
    // 1) Sunrise until the sun has sufficiently risen.
    // 2) Solar zenith / zawal until Dhuhr begins.
    // 3) Sunset period.
    //
    // The post-Asr period is separately represented as a nafl prohibition.
    final sunriseForbiddenEnd =
        sunrise.add(const Duration(minutes: 20));

    final sunsetForbiddenStart =
        maghrib.subtract(const Duration(minutes: 20));

    final forbidden = <ForbiddenPrayerTime>[
      ForbiddenPrayerTime(
        name: 'সূর্যোদয়ের নিষিদ্ধ ওয়াক্ত',
        start: sunrise,
        end: sunriseForbiddenEnd,
        description: 'সূর্যোদয় থেকে সূর্য পূর্ণভাবে উপরে ওঠা পর্যন্ত',
      ),
      ForbiddenPrayerTime(
        name: 'জাওয়ালের নিষিদ্ধ ওয়াক্ত',
        start: solarNoon,
        end: dhuhr,
        description: 'সূর্য মধ্যাকাশে অবস্থান থেকে ঢলে যাওয়া পর্যন্ত',
      ),
      ForbiddenPrayerTime(
        name: 'সূর্যাস্তের নিষিদ্ধ ওয়াক্ত',
        start: sunsetForbiddenStart,
        end: maghrib,
        description: 'সূর্যাস্তের পূর্ববর্তী শেষ সময়',
      ),
      ForbiddenPrayerTime(
        name: 'আসরের পর নফল নামাজের নিষিদ্ধ সময়',
        start: asr,
        end: maghrib,
        description: 'আসর শুরু হওয়ার পর থেকে মাগরিব পর্যন্ত নফল নামাজ আদায় করা হয় না',
      ),
    ];

    return PrayerDayTimes(
      date: date,
      location:
          '${_coordinates.latitude.toStringAsFixed(4)}, '
          '${_coordinates.longitude.toStringAsFixed(4)}',
      fajr: PrayerTime(
        name: 'ফজর',
        time: fajr,
        endTime: fajrEnd,
      ),
      dhuhr: PrayerTime(
        name: 'যোহর',
        time: dhuhr,
        endTime: dhuhrEnd,
      ),
      asr: PrayerTime(
        name: 'আসর',
        time: asr,
        endTime: asrEnd,
      ),
      maghrib: PrayerTime(
        name: 'মাগরিব',
        time: maghrib,
        endTime: maghribEnd,
      ),
      isha: PrayerTime(
        name: 'এশা',
        time: isha,
        endTime: ishaEnd,
      ),
      sunrise: sunrise,
      sunset: maghrib,
      solarNoon: solarNoon,
      forbiddenTimes: forbidden,
    );
  }

  PrayerDayTimes getTodayPrayerTimes() {
    return getPrayerTimes(DateTime.now());
  }
}
