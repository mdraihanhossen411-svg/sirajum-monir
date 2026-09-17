import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<String> featureTitles = [
    "কুরআন",
    "হাদিস",
    "দোয়া",
    "তাসবিহ",
    "নামাজ",
    "কিবলা",
    "হিজরি",
    "সেটিংস",
  ];
  final List<IconData> featureIcons = [
    Icons.menu_book,
    Icons.library_books,
    Icons.favorite,
    Icons.repeat,
    Icons.access_time,
    Icons.explore,
    Icons.calendar_month,
    Icons.book,
    Icons.settings,
  ];
}