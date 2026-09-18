import 'package:flutter/foundation.dart';

class BooksController extends ChangeNotifier {
  String query = '';
  String? category;

  void search(String value) {
    query = value;
    notifyListeners();
  }

  void selectCategory(String? value) {
    category = value;
    notifyListeners();
  }
}
