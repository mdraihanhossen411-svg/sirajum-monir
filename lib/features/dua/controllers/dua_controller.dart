import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dua_models.dart';

class DuaController extends ChangeNotifier {
  static const _key = 'sirajum_dua_favorites_v1';

  Set<String> _favorites = {};
  bool _loaded = false;

  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool get isLoaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = (prefs.getStringList(_key) ?? <String>[]).toSet();
    _loaded = true;
    notifyListeners();
  }

  bool isFavorite(DuaItem item) => _favorites.contains(item.id);

  Future<void> toggleFavorite(DuaItem item) async {
    if (_favorites.contains(item.id)) {
      _favorites.remove(item.id);
    } else {
      _favorites.add(item.id);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favorites.toList()..sort());
  }
}
