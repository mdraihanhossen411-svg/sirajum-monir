import 'package:flutter/foundation.dart';

class TafsirController extends ChangeNotifier {
  String query = '';

  void search(String value) {
    query = value;
    notifyListeners();
  }
}
