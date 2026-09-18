import 'package:flutter/foundation.dart';

class FatwaController extends ChangeNotifier {
  String searchQuery = '';

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }
}
