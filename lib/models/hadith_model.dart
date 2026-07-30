class HadithModel {
  final int id;
  final int hadithNumber;
  final String bookName;
  final String chapterName;
  final String arabicText;
  final String banglaTranslation;
  final String englishTranslation;
  final String narrator;
  final String grade;
  final bool isFavorite;

  const HadithModel({
    required this.id,
    required this.hadithNumber,
    required this.bookName,
    required this.chapterName,
    required this.arabicText,
    required this.banglaTranslation,
    required this.englishTranslation,
    required this.narrator,
    required this.grade,
    this.isFavorite = false,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'],
      hadithNumber: json['hadithNumber'],
      bookName: json['bookName'],
      chapterName: json['chapterName'],
      arabicText: json['arabicText'],
      banglaTranslation: json['banglaTranslation'],
      englishTranslation: json['englishTranslation'],
      narrator: json['narrator'],
      grade: json['grade'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hadithNumber': hadithNumber,
      'bookName': bookName,
      'chapterName': chapterName,
      'arabicText': arabicText,
      'banglaTranslation': banglaTranslation,
      'englishTranslation': englishTranslation,
      'narrator': narrator,
      'grade': grade,
      'isFavorite': isFavorite,
    };
  }
}
