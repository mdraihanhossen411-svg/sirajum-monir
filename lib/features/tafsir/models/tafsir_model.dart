class TafsirModel {
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String banglaText;
  final String source;

  const TafsirModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.banglaText,
    required this.source,
  });
}
