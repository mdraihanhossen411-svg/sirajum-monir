class SurahModel {
  final int id;
  final String arabicName;
  final String englishName;
  final String banglaName;
  final int totalAyah;
  final String revelationType;

  const SurahModel({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.banglaName,
    required this.totalAyah,
    required this.revelationType,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] ?? 0,
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      banglaName: json['banglaName'] ?? '',
      totalAyah: json['totalAyah'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'banglaName': banglaName,
      'totalAyah': totalAyah,
      'revelationType': revelationType,
    };
  }
}

class AyahModel {
  final int number;
  final String arabicText;
  final String banglaText;
  final String englishText;

  const AyahModel({
    required this.number,
    required this.arabicText,
    required this.banglaText,
    required this.englishText,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] ?? 0,
      arabicText: json['arabicText'] ?? '',
      banglaText: json['banglaText'] ?? '',
      englishText: json['englishText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'arabicText': arabicText,
      'banglaText': banglaText,
      'englishText': englishText,
    };
  }
}