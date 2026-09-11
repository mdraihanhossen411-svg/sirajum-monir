import 'package:flutter/foundation.dart';
import '../models/quran_model.dart';
import '../services/quran_service.dart';
import 'quran_controller.dart';

enum QuranSearchMode { surah, ayah }

class QuranSearchResult {
  final SurahModel surah;
  final int ayahNumber;
  final String arabicText;
  final String banglaText;

  const QuranSearchResult({
    required this.surah,
    required this.ayahNumber,
    required this.arabicText,
    required this.banglaText,
  });
}

class QuranSearchController extends ChangeNotifier {
  final QuranService _service = QuranService();

  final List<SurahModel> _allSurahs = [];
  final List<QuranSearchResult> _allAyahs = [];

  List<SurahModel> _surahs = [];
  List<QuranSearchResult> _results = [];

  QuranSearchMode _mode = QuranSearchMode.surah;
  bool _isLoading = false;
  bool _loaded = false;
  String? _error;
  String _query = '';

  List<SurahModel> get surahs => List.unmodifiable(_surahs);
  List<QuranSearchResult> get results => List.unmodifiable(_results);
  QuranSearchMode get mode => _mode;
  bool get isLoading => _isLoading;
  bool get isLoaded => _loaded;
  String? get error => _error;
  String get query => _query;

  Future<void> load() async {
    if (_loaded || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.loadAllSurahCore();

      _allSurahs.clear();
      _allAyahs.clear();

      for (final item in data) {
        final id = item['surahNumber'] as int;

        final surah = SurahModel(
          id: id,
          arabicName: item['arabicName'] as String? ?? '',
          englishName: item['englishName'] as String? ?? '',
          banglaName: QuranController.banglaSurahName(id),
          totalAyah: item['totalAyah'] as int? ?? 0,
          revelationType: '',
        );

        _allSurahs.add(surah);

        for (final raw in item['ayahs'] as List<dynamic>? ?? []) {
          final ayah = Map<String, dynamic>.from(raw as Map);
          _allAyahs.add(QuranSearchResult(
            surah: surah,
            ayahNumber: ayah['number'] as int? ?? 0,
            arabicText: ayah['arabicText'] as String? ?? '',
            banglaText: ayah['banglaText'] as String? ?? '',
          ));
        }
      }

      _loaded = true;
      _applySearch();
    } catch (e) {
      _error = e.toString();
      debugPrint('Quran Search Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setMode(QuranSearchMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _query = '';
    _applySearch();
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    if (!_loaded) {
      notifyListeners();
      return;
    }
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    final q = _normalize(_query);

    if (_mode == QuranSearchMode.surah) {
      _surahs = q.isEmpty
          ? List.unmodifiable(_allSurahs)
          : _allSurahs.where((s) {
              return _normalize(s.banglaName).contains(q) ||
                  _normalize(s.arabicName).contains(q) ||
                  _normalize(s.englishName).contains(q) ||
                  _normalize(s.id.toString()) == q ||
                  _toBengaliDigits(s.id.toString()) == q;
            }).toList();
      _results = [];
      return;
    }

    _surahs = [];
    _results = q.isEmpty
        ? []
        : _allAyahs.where((a) {
            return _normalize(a.arabicText).contains(q) ||
                _normalize(a.banglaText).contains(q);
          }).toList();
  }

  String _normalize(String value) {
    return _normalizeArabic(
      _normalizeDigits(value),
    ).toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _normalizeArabic(String value) {
    return value
        .replaceAll(RegExp(r'[\\u0610-\\u061A\\u064B-\\u065F\\u0670\\u06D6-\\u06ED]'), '')
        .replaceAll('ٱ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
  }

  String _normalizeDigits(String value) {
    const b = '০১২৩৪৫৬৭৮৯';
    const e = '0123456789';
    var r = value;
    for (var i = 0; i < 10; i++) {
      r = r.replaceAll(b[i], e[i]);
    }
    return r;
  }

  String _toBengaliDigits(String value) {
    const e = '0123456789';
    const b = '০১২৩৪৫৬৭৮৯';
    var r = value;
    for (var i = 0; i < 10; i++) {
      r = r.replaceAll(e[i], b[i]);
    }
    return r;
  }
}
