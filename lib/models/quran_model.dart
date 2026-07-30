class QuranModel {
  final int id;
  final int surahNumber;
  final String surahNameArabic;
  final String surahNameEnglish;
  final String surahNameBangla;
  final int totalAyah;
  final String revelationType;
  final String translation;
  final String audioUrl;
  final bool isFavorite;
  final bool isDownloaded;

  const QuranModel({
    required this.id,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.surahNameBangla,
    required this.totalAyah,
    required this.revelationType,
    required this.translation,
    required this.audioUrl,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  factory QuranModel.fromJson(Map<String, dynamic> json) {
    return QuranModel(
      id: json['id'],
      surahNumber: json['surahNumber'],
      surahNameArabic: json['surahNameArabic'],
      surahNameEnglish: json['surahNameEnglish'],
      surahNameBangla: json['surahNameBangla'],
      totalAyah: json['totalAyah'],
      revelationType: json['revelationType'],
      translation: json['translation'],
      audioUrl: json['audioUrl'],
      isFavorite: json['isFavorite'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahNameArabic': surahNameArabic,
      'surahNameEnglish': surahNameEnglish,
      'surahNameBangla': surahNameBangla,
      'totalAyah': totalAyah,
      'revelationType': revelationType,
      'translation': translation,
      'audioUrl': audioUrl,
      'isFavorite': isFavorite,
      'isDownloaded': isDownloaded,
    };
  }
}
