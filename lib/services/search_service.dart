class SearchService {
  Future<List<String>> search(String query) async {
    final List<String> items = [
      "Quran",
      "Hadith",
      "Dua",
      "Prayer",
      "Tasbih",
      "Qibla",
      "Islamic Books",
      "Calendar",
    ];

    return items
        .where(
          (item) => item.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> clearHistory() async {
    // Search history will be cleared here.
  }

  Future<List<String>> recentSearches() async {
    return [];
  }
}
