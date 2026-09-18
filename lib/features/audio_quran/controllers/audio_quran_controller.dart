import 'package:flutter/foundation.dart';

class AudioQuranController extends ChangeNotifier {
  bool isPlaying = false;

  void togglePlay() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void stop() {
    isPlaying = false;
    notifyListeners();
  }
}
