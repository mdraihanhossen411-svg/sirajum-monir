class DuaService {
  Future<List<String>> getDuaList() async {
    return [
      "Morning Dua",
      "Evening Dua",
      "Before Sleep Dua",
      "After Prayer Dua",
      "Travel Dua",
    ];
  }

  Future<String> getDua(int index) async {
    return "Dua details will be loaded here.";
  }
}
