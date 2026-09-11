class JuzModel {
  final int number;
  final String name;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;

  JuzModel({
    required this.number,
    required this.name,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) {
    return JuzModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      startSurah: json['startSurah'] ?? 0,
      startAyah: json['startAyah'] ?? 0,
      endSurah: json['endSurah'] ?? 0,
      endAyah: json['endAyah'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'startSurah': startSurah,
      'startAyah': startAyah,
      'endSurah': endSurah,
      'endAyah': endAyah,
    };
  }
}
