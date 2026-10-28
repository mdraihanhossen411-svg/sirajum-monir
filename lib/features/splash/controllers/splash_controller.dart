import 'dart:async';

import 'package:flutter/material.dart';

class SplashController {
  Timer? _timer;

  void initialize(VoidCallback onComplete) {
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 2), () {
      _timer = null;
      onComplete();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
