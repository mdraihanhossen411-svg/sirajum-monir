class PrayerTime {
  final String name;
  final DateTime time;
  final DateTime endTime;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.endTime,
  });
}

class ForbiddenPrayerTime {
  final String name;
  final DateTime start;
  final DateTime end;
  final String description;

  const ForbiddenPrayerTime({
    required this.name,
    required this.start,
    required this.end,
    required this.description,
  });
}

class PrayerDayTimes {
  final DateTime date;
  final String location;

  final PrayerTime fajr;
  final PrayerTime dhuhr;
  final PrayerTime asr;
  final PrayerTime maghrib;
  final PrayerTime isha;

  final DateTime sunrise;
  final DateTime sunset;
  final DateTime solarNoon;

  final List<ForbiddenPrayerTime> forbiddenTimes;

  const PrayerDayTimes({
    required this.date,
    required this.location,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.sunset,
    required this.solarNoon,
    required this.forbiddenTimes,
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
