class DailyItem {
  final String title;
  final int surahNumber;
  final String surahName;
  final String ayahNumber;
  final String text;
  final String source;

  const DailyItem({
    required this.title,
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.text,
    required this.source,
  });

  factory DailyItem.fromJson(Map<String, dynamic> json) {
    return DailyItem(
      title: json['title'] ?? 'আজকের আয়াত',
      surahNumber: json['surahNumber'] ?? 0,
      surahName: json['surahName'] ?? '',
      ayahNumber: json['ayahNumber'] ?? '',
      text: json['text'] ?? '',
      source: json['source'] ?? '',
    );
  }
}

class DailyContent {
  final DailyItem ayah;
  final DailyItem hadith;
  final DailyItem dua;
  final DailyItem amal;

  const DailyContent({
    required this.ayah,
    required this.hadith,
    required this.dua,
    required this.amal,
  });

  factory DailyContent.fromJson(Map<String, dynamic> json) {
    return DailyContent(
      ayah: DailyItem.fromJson(
        Map<String, dynamic>.from(json['ayah'] ?? {}),
      ),
      hadith: DailyItem.fromJson(
        Map<String, dynamic>.from(json['hadith'] ?? {}),
      ),
      dua: DailyItem.fromJson(
        Map<String, dynamic>.from(json['dua'] ?? {}),
      ),
      amal: DailyItem.fromJson(
        Map<String, dynamic>.from(json['amal'] ?? {}),
      ),
    );
  }
}
