import 'package:shared_preferences/shared_preferences.dart';

class LastReadService {
  static const String _surahIdKey = 'quran_last_read_surah_id';
  static const String _surahBanglaKey = 'quran_last_read_surah_bangla';
  static const String _surahArabicKey = 'quran_last_read_surah_arabic';
  static const String _surahEnglishKey = 'quran_last_read_surah_english';
  static const String _ayahNumberKey = 'quran_last_read_ayah_number';
  static const String _totalAyahKey = 'quran_last_read_total_ayah';

  Future<void> save({
    required int surahId,
    required String surahBangla,
    required String surahArabic,
    required String surahEnglish,
    required int ayahNumber,
    required int totalAyah,
  }) async {
    if (surahId <= 0 || ayahNumber <= 0) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_surahIdKey, surahId);
    await prefs.setString(_surahBanglaKey, surahBangla);
    await prefs.setString(_surahArabicKey, surahArabic);
    await prefs.setString(_surahEnglishKey, surahEnglish);
    await prefs.setInt(_ayahNumberKey, ayahNumber);
    await prefs.setInt(_totalAyahKey, totalAyah);
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();

    final surahId = prefs.getInt(_surahIdKey);
    final ayahNumber = prefs.getInt(_ayahNumberKey);

    if (surahId == null || ayahNumber == null) {
      return null;
    }

    if (surahId <= 0 || ayahNumber <= 0) {
      return null;
    }

    return {
      'surahId': surahId,
      'surahBangla': prefs.getString(_surahBanglaKey) ?? '',
      'surahArabic': prefs.getString(_surahArabicKey) ?? '',
      'surahEnglish': prefs.getString(_surahEnglishKey) ?? '',
      'ayahNumber': ayahNumber,
      'totalAyah': prefs.getInt(_totalAyahKey) ?? 0,
    };
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_surahIdKey);
    await prefs.remove(_surahBanglaKey);
    await prefs.remove(_surahArabicKey);
    await prefs.remove(_surahEnglishKey);
    await prefs.remove(_ayahNumberKey);
    await prefs.remove(_totalAyahKey);
  }
}
