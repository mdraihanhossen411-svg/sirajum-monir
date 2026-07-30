class BookModel {
  final int id;
  final String title;
  final String author;
  final String category;
  final String language;
  final String description;
  final String coverImage;
  final String pdfPath;
  final bool isDownloaded;
  final bool isFavorite;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.language,
    required this.description,
    required this.coverImage,
    required this.pdfPath,
    this.isDownloaded = false,
    this.isFavorite = false,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      category: json["category"],
      language: json["language"],
      description: json["description"],
      coverImage: json["coverImage"],
      pdfPath: json["pdfPath"],
      isDownloaded: json["isDownloaded"] ?? false,
      isFavorite: json["isFavorite"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "author": author,
      "category": category,
      "language": language,
      "description": description,
      "coverImage": coverImage,
      "pdfPath": pdfPath,
      "isDownloaded": isDownloaded,
      "isFavorite": isFavorite,
    };
  }
}
