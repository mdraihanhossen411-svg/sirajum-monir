class BookService {
  Future<List<String>> getBookList() async {
    return [
      "Holy Quran",
      "Sahih Bukhari",
      "Sahih Muslim",
      "Riyadus Saliheen",
      "Hisnul Muslim",
    ];
  }

  Future<String> getBookDetails(String bookName) async {
    return "$bookName details will be loaded here.";
  }

  Future<bool> downloadBook(String bookName) async {
    // Download feature will be added later.
    return true;
  }

  Future<List<String>> getOfflineBooks() async {
    return [];
  }
}
