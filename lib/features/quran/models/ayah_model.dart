class AyahModel {
  final int number;
  final int surahNumber;
  final String surahNameArabic;
  final String surahNameBangla;
  final int juz;
  final int page;
  final String arabicText;
  final String banglaTranslation;

  AyahModel({
    required this.number,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.surahNameBangla,
    required this.juz,
    required this.page,
    required this.arabicText,
    required this.banglaTranslation,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json["number"] ?? 0,
      surahNumber: json["surahNumber"] ?? 0,
      surahNameArabic: json["surahNameArabic"] ?? "",
      surahNameBangla: json["surahNameBangla"] ?? "",
      juz: json["juz"] ?? 0,
      page: json["page"] ?? 0,
      arabicText: json["arabicText"] ?? "",
      banglaTranslation: json["banglaTranslation"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "surahNumber": surahNumber,
      "surahNameArabic": surahNameArabic,
      "surahNameBangla": surahNameBangla,
      "juz": juz,
      "page": page,
      "arabicText": arabicText,
      "banglaTranslation": banglaTranslation,
    };
  }
}