class Hadith {
  final int id;
  final String collection;
  final String publisher;
  final String volume;
  final String chapter;
  final int hadithNumber;
  final String narrator;
  final String arabic;
  final String bengali;
  final String reference;
  final String grade;

  const Hadith({
    required this.id,
    required this.collection,
    required this.publisher,
    required this.volume,
    required this.chapter,
    required this.hadithNumber,
    required this.narrator,
    required this.arabic,
    required this.bengali,
    required this.reference,
    required this.grade,
  });
}
