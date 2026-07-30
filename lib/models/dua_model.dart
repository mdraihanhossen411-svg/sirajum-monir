class DuaModel {
  final int id;
  final String title;
  final String category;
  final String arabicText;
  final String banglaTranslation;
  final String englishTranslation;
  final String reference;
  final bool isFavorite;

  const DuaModel({
    required this.id,
    required this.title,
    required this.category,
    required this.arabicText,
    required this.banglaTranslation,
    required this.englishTranslation,
    required this.reference,
    this.isFavorite = false,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      arabicText: json['arabicText'],
      banglaTranslation: json['banglaTranslation'],
      englishTranslation: json['englishTranslation'],
      reference: json['reference'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'arabicText': arabicText,
      'banglaTranslation': banglaTranslation,
      'englishTranslation': englishTranslation,
      'reference': reference,
      'isFavorite': isFavorite,
    };
  }
}
