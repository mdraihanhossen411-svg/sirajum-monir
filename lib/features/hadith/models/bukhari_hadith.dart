class BukhariHadith {
  final int number;
  final String internationalNumber;
  final String chapter;
  final String narrator;
  final String arabic;
  final String bengali;
  final String grade;
  final String note;

  const BukhariHadith({
    required this.number,
    required this.internationalNumber,
    required this.chapter,
    required this.narrator,
    required this.arabic,
    required this.bengali,
    required this.grade,
    required this.note,
  });

  String get id => 'bukhari_ifa_$number';
}
