class PrayerService {
  Future<List<String>> getPrayerTimes() async {
    return [
      "Fajr",
      "Dhuhr",
      "Asr",
      "Maghrib",
      "Isha",
    ];
  }

  Future<String> getPrayerTime(String prayerName) async {
    return "$prayerName time will be loaded here.";
  }

  Future<bool> refreshPrayerTimes() async {
    return true;
  }
}
