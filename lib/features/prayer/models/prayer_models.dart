class PrayerTime {
  final String name;
  final DateTime time;

  const PrayerTime({
    required this.name,
    required this.time,
  });
}

class PrayerDayTimes {
  final DateTime date;
  final String location;

  final PrayerTime fajr;
  final PrayerTime sunrise;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  const PrayerDayTimes({
    required this.date,
    required this.location,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<PrayerTime> get allPrayers {
    return [
      fajr,
      dhuhr,
      asr,
      maghrib,
      isha,
    ];
  }
}