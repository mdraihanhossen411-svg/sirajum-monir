import 'package:flutter/foundation.dart';

class TasawwufController extends ChangeNotifier {
  String query = '';

  void search(String value) {
    query = value;
    notifyListeners();
  }
}
