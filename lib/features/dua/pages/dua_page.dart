import 'package:flutter/material.dart';

import '../controllers/dua_controller.dart';
import '../models/dua_models.dart';
import '../widgets/dua_card.dart';

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  late final DuaController _controller;
  final TextEditingController _search = TextEditingController();

  List<DuaItem> _items = const [];
  bool _loading = true;
  String? _loadError;
  String _category = 'সব';
  bool _favoritesOnly = false;

  List<String> get _categories {
    final categories = _items.map((item) => item.category).toSet().toList()
      ..sort();
    return ['সব', ...categories];
  }

  @override
  void initState() {
    super.initState();
    _controller = DuaController();
    _controller.addListener(_refresh);
    _controller.load();
    _search.addListener(_refresh);
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final items = await loadDuaItems();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = error.toString();
      });
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    _search.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final items = _items.where((dua) {
      final categoryMatch = _category == 'সব' || dua.category == _category;
      final favoriteMatch = !_favoritesOnly || _controller.isFavorite(dua);
      final searchable = [
        dua.title,
        dua.category,
        dua.arabic,
        dua.meaning,
        dua.pronunciation,
        dua.source,
      ].join(' ').toLowerCase();
      final searchMatch = query.isEmpty || searchable.contains(query);
      return categoryMatch && favoriteMatch && searchMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('দোয়া ও মুনাজাত'),
        backgroundColor: const Color(0xFF0A8754),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: _favoritesOnly ? 'সব দোয়া দেখুন' : 'পছন্দের দোয়া',
            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
            icon: Icon(_favoritesOnly ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'বাংলা বা আরবি দিয়ে দোয়া খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _search.clear,
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _loadError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'দোয়ার ডেটা লোড করা যায়নি।',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _loadError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loading = true;
                                _loadError = null;
                              });
                              _loadItems();
                            },
                            child: const Text('আবার চেষ্টা করুন'),
                          ),
                        ],
                      ),
                    ),
                  )
                : items.isEmpty
                ? const Center(child: Text('কোনো দোয়া পাওয়া যায়নি।'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final dua = items[index];
                      return DuaCard(
                        dua: dua,
                        favorite: _controller.isFavorite(dua),
                        onFavorite: () => _controller.toggleFavorite(dua),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
