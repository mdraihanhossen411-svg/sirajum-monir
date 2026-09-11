import 'dart:convert';
import 'package:flutter/services.dart';

class QuranService {
  Future<Map<String, dynamic>> loadSurahCore(int surahNumber) async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/core/surah_$surahNumber.json',
    );

    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> loadAllSurahCore() async {
    final List<Map<String, dynamic>> surahs = [];

    for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
      final data = await loadSurahCore(surahNumber);
      surahs.add(data);
    }

    return surahs;
  }

  Future<List<dynamic>> loadSurahList() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/surah_list.json',
    );
    return json.decode(jsonString);
  }

  Future<List<dynamic>> loadQuranBn() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/quran_bn.json',
    );
    return json.decode(jsonString);
  }

  Future<List<dynamic>> loadQuranAr() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/quran_ar.json',
    );
    return json.decode(jsonString);
  }

  Future<List<dynamic>> loadJuz() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/quran/juz.json',
    );
    return json.decode(jsonString);
  }
}
