class HadithService {
  Future<List<String>> getHadithList() async {
    return [
      "Hadith 1",
      "Hadith 2",
      "Hadith 3",
      "Hadith 4",
      "Hadith 5",
    ];
  }

  Future<String> getHadith(int index) async {
    return "Hadith details will be loaded here.";
  }
}
