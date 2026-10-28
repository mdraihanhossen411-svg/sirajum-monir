import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tasbih_model.dart';

class TasbihController extends ChangeNotifier {
  static const _savedKey = 'sirajum_tasbih_counts_v1';
  static const _customKey = 'sirajum_tasbih_custom_v1';
  static const _targetKey = 'sirajum_tasbih_targets_v1';
  static const _dailyKey = 'sirajum_tasbih_daily_v1';

  final List<TasbihData> builtIn = BuiltInTasbihData.items;
  final List<TasbihData> custom = [];

  int selectedIndex = 0;
  int target = 33;
  int? _previousCount;
  int? _previousDailyCount;
  bool loading = true;
  bool _disposed = false;
  final Map<String, int> _todayCounts = {};

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  TasbihData get selected {
    if (selectedIndex < builtIn.length) {
      return builtIn[selectedIndex];
    }

    return custom[selectedIndex - builtIn.length];
  }

  List<TasbihData> get all => [...builtIn, ...custom];

  int get count => selected.count;

  double get progress {
    if (target <= 0) return 0;
    return (count / target).clamp(0.0, 1.0);
  }

  bool get completed => count >= target;

  int get todayCount => _todayCounts[selected.id] ?? 0;

  int get todayTotal =>
      _todayCounts.values.fold<int>(0, (sum, value) => sum + value);

  String get _todayKey {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  Future<List<Map<String, dynamic>>> getDailyHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw);
    if (decoded is! Map) return [];

    final history = <Map<String, dynamic>>[];

    for (final entry in decoded.entries) {
      final date = entry.key.toString();
      final values = entry.value;

      if (values is! Map) continue;

      final items = <Map<String, dynamic>>[];
      var total = 0;

      for (final valueEntry in values.entries) {
        final id = valueEntry.key.toString();
        final value = valueEntry.value;

        if (value is! num || value <= 0) continue;

        final count = value.toInt();
        total += count;

        TasbihData? item;

        for (final builtInItem in builtIn) {
          if (builtInItem.id == id) {
            item = builtInItem;
            break;
          }
        }

        if (item == null) {
          for (final customItem in custom) {
            if (customItem.id == id) {
              item = customItem;
              break;
            }
          }
        }

        items.add({
          'id': id,
          'title': item?.title ?? 'মুছে ফেলা যিকির',
          'arabic': item?.arabic ?? '',
          'count': count,
        });
      }

      items.sort(
        (a, b) => (b['count'] as int).compareTo(a['count'] as int),
      );

      history.add({
        'date': date,
        'total': total,
        'items': items,
      });
    }

    history.sort(
      (a, b) => b['date'].toString().compareTo(a['date'].toString()),
    );

    return history;
  }


  Future<void> clearDailyHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_dailyKey);
    _todayCounts.clear();

    _safeNotify();
  }

  Future<void> init() async {
    loading = true;
    _safeNotify();

    final prefs = await SharedPreferences.getInstance();
    if (_disposed) return;

    final countsRaw = prefs.getString(_savedKey);
    if (countsRaw != null) {
      final counts = Map<String, dynamic>.from(jsonDecode(countsRaw));
      for (final item in builtIn) {
        final value = counts[item.id];
        if (value is num) {
          item.count = value.toInt();
        }
      }
    }

    final targetsRaw = prefs.getString(_targetKey);
    if (targetsRaw != null) {
      final targets = Map<String, dynamic>.from(jsonDecode(targetsRaw));
      for (final item in builtIn) {
        final value = targets[item.id];
        if (value is num && value.toInt() > 0) {
          item.defaultTarget = value.toInt();
        }
      }
    }

    final dailyRaw = prefs.getString(_dailyKey);
    if (dailyRaw != null) {
      final decoded = jsonDecode(dailyRaw);
      if (decoded is Map) {
        final today = decoded[_todayKey];
        if (today is Map) {
          _todayCounts
            ..clear()
            ..addAll(
              today.map(
                (key, value) => MapEntry(
                  key.toString(),
                  value is num ? value.toInt() : 0,
                ),
              ),
            );
        }
      }
    }

    final customRaw = prefs.getString(_customKey);
    if (customRaw != null) {
      final list = jsonDecode(customRaw);
      if (list is List) {
        custom
          ..clear()
          ..addAll(
            list.map(
              (e) => TasbihData.fromJson(
                Map<String, dynamic>.from(e),
              ),
            ),
          );
      }
    }

    if (_disposed) return;
    loading = false;
    _safeNotify();
  }

  Future<void> increment() async {
    if (count >= target) return;

    _previousCount = count;
    _previousDailyCount = todayCount;

    selected.count++;
    _todayCounts[selected.id] = todayCount + 1;

    _safeNotify();
    await _save();
  }

  Future<void> undo() async {
    if (_previousCount == null) return;

    selected.count = _previousCount!;

    if (_previousDailyCount != null) {
      _todayCounts[selected.id] = _previousDailyCount!;
    }

    _previousCount = null;
    _previousDailyCount = null;

    _safeNotify();
    await _save();
  }

  Future<void> reset() async {
    selected.count = 0;

    // Reset শুধু বর্তমান কাউন্টার শূন্য করে।
    // আজকের History অপরিবর্তিত থাকবে।
    _previousCount = null;
    _previousDailyCount = null;

    _safeNotify();
    await _save();
  }

  Future<void> setTarget(int value) async {
    if (value <= 0) return;

    target = value;
    selected.defaultTarget = value;

    _safeNotify();
    await _save();
  }

  void selectByIndex(int index) {
    if (index < 0 || index >= all.length) return;

    selectedIndex = index;
    target = all[index].defaultTarget;

    _previousCount = null;
    _previousDailyCount = null;
    _safeNotify();
  }

  Future<void> addCustom({
    required String title,
    required String arabic,
    required String pronunciation,
    required String meaning,
    required int target,
  }) async {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty || target <= 0) return;

    final id = 'custom_${DateTime.now().microsecondsSinceEpoch}';

    custom.add(
      TasbihData(
        id: id,
        category: 'আমার যিকির',
        title: cleanTitle,
        arabic: arabic.trim(),
        pronunciation: pronunciation.trim(),
        meaning: meaning.trim(),
        defaultTarget: target,
      ),
    );

    selectedIndex = builtIn.length + custom.length - 1;
    this.target = target;
    _previousCount = null;

    _safeNotify();
    await _save();
  }

  Future<void> updateCustom({
    required int index,
    required String title,
    required String arabic,
    required String pronunciation,
    required String meaning,
    required int target,
  }) async {
    if (index < 0 || index >= custom.length) return;

    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty || target <= 0) return;

    final item = custom[index];

    item.title = cleanTitle;
    item.arabic = arabic.trim();
    item.pronunciation = pronunciation.trim();
    item.meaning = meaning.trim();
    item.defaultTarget = target;

    final absoluteIndex = builtIn.length + index;
    if (selectedIndex == absoluteIndex) {
      this.target = target;
    }

    _safeNotify();
    await _save();
  }

  Future<void> deleteCustom(int index) async {
    if (index < 0 || index >= custom.length) return;

    final absoluteIndex = builtIn.length + index;

    custom.removeAt(index);

    if (all.isEmpty) {
      selectedIndex = 0;
      target = 33;
    } else if (selectedIndex == absoluteIndex) {
      selectedIndex = selectedIndex >= all.length
          ? all.length - 1
          : selectedIndex;
      target = all[selectedIndex].defaultTarget;
    } else if (selectedIndex > absoluteIndex) {
      selectedIndex--;
    }

    _previousCount = null;

    _safeNotify();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final counts = <String, int>{};
    final targets = <String, int>{};

    for (final item in all) {
      counts[item.id] = item.count;
      targets[item.id] = item.defaultTarget;
    }

    await prefs.setString(_savedKey, jsonEncode(counts));
    await prefs.setString(_targetKey, jsonEncode(targets));
    await prefs.setString(
      _customKey,
      jsonEncode(custom.map((e) => e.toJson()).toList()),
    );

    final dailyRaw = prefs.getString(_dailyKey);
    Map<String, dynamic> daily = {};
    if (dailyRaw != null) {
      final decoded = jsonDecode(dailyRaw);
      if (decoded is Map) {
        daily = Map<String, dynamic>.from(decoded);
      }
    }

    daily[_todayKey] = Map<String, int>.from(_todayCounts);
    await prefs.setString(_dailyKey, jsonEncode(daily));
  }
}
