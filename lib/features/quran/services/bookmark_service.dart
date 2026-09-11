import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const _key = 'quran_bookmarks';

  Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<bool> toggle(Map<String, dynamic> bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load();

    final index = list.indexWhere(
      (e) =>
          e['surahId'] == bookmark['surahId'] &&
          e['ayahNumber'] == bookmark['ayahNumber'],
    );

    final saved = index < 0;

    if (saved) {
      list.insert(0, bookmark);
    } else {
      list.removeAt(index);
    }

    await prefs.setString(_key, jsonEncode(list));
    return saved;
  }

  Future<void> remove(int surahId, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load();

    list.removeWhere(
      (e) => e['surahId'] == surahId && e['ayahNumber'] == ayahNumber,
    );

    await prefs.setString(_key, jsonEncode(list));
  }
}
