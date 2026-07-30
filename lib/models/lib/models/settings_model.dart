class SettingsModel {
  final bool darkMode;
  final bool notificationsEnabled;
  final bool prayerReminder;
  final bool quranAudioAutoPlay;
  final String language;
  final String madhab;

  const SettingsModel({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.prayerReminder = true,
    this.quranAudioAutoPlay = false,
    this.language = "bn",
    this.madhab = "Hanafi",
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      darkMode: json['darkMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      prayerReminder: json['prayerReminder'] ?? true,
      quranAudioAutoPlay: json['quranAudioAutoPlay'] ?? false,
      language: json['language'] ?? "bn",
      madhab: json['madhab'] ?? "Hanafi",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'prayerReminder': prayerReminder,
      'quranAudioAutoPlay': quranAudioAutoPlay,
      'language': language,
      'madhab': madhab,
    };
  }

  SettingsModel copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? prayerReminder,
    bool? quranAudioAutoPlay,
    String? language,
    String? madhab,
  }) {
    return SettingsModel(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      prayerReminder: prayerReminder ?? this.prayerReminder,
      quranAudioAutoPlay:
          quranAudioAutoPlay ?? this.quranAudioAutoPlay,
      language: language ?? this.language,
      madhab: madhab ?? this.madhab,
    );
  }
}
