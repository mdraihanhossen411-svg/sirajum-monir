class QuranService {
  Future<List<String>> getSurahList() async {
    return [
      "Al-Fatihah",
      "Al-Baqarah",
      "Ali 'Imran",
      "An-Nisa",
      "Al-Ma'idah",
      "Al-An'am",
      "Al-A'raf",
      "Al-Anfal",
      "At-Tawbah",
      "Yunus",
    ];
  }

  Future<String> getSurah(int index) async {
    return "Surah content will be loaded here.";
  }
}
