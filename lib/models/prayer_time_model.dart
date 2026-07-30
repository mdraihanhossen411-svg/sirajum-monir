class PrayerTimeModel {
  final String date;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;

  const PrayerTimeModel({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      date: json['date'],
      fajr: json['fajr'],
      dhuhr: json['dhuhr'],
      asr: json['asr'],
      maghrib: json['maghrib'],
      isha: json['isha'],
      sunrise: json['sunrise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'sunrise': sunrise,
    };
  }
}
