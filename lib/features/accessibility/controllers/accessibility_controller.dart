import 'package:flutter/foundation.dart';

class AccessibilityController extends ChangeNotifier {
  bool _enabled = false;

  bool get enabled => _enabled;

  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }
}
