class BookmarkModel {
  final int surahNumber;
  final String surahNameArabic;
  final String surahNameBangla;
  final int ayahNumber;
  final String arabicText;
  final String banglaTranslation;
  final DateTime createdAt;

  BookmarkModel({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.surahNameBangla,
    required this.ayahNumber,
    required this.arabicText,
    required this.banglaTranslation,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      surahNumber: json["surahNumber"] ?? 0,
      surahNameArabic: json["surahNameArabic"] ?? "",
      surahNameBangla: json["surahNameBangla"] ?? "",
      ayahNumber: json["ayahNumber"] ?? 0,
      arabicText: json["arabicText"] ?? "",
      banglaTranslation: json["banglaTranslation"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "surahNumber": surahNumber,
      "surahNameArabic": surahNameArabic,
      "surahNameBangla": surahNameBangla,
      "ayahNumber": ayahNumber,
      "arabicText": arabicText,
      "banglaTranslation": banglaTranslation,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}