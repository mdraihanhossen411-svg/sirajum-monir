import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../models/qibla_models.dart';

class QiblaController extends ChangeNotifier {
  StreamSubscription<CompassEvent>? _compassSubscription;

  QiblaData? qiblaData;

  double? heading;
  double? sensorAccuracy;

  bool loading = true;
  bool locationError = false;
  bool compassAvailable = true;
  bool detailsExpanded = false;
  bool calibrationNeeded = false;

  bool _wasAligned = false;

  QiblaController() {
    initialize();
  }

  Future<void> initialize() async {
    loading = true;
    locationError = false;
    notifyListeners();

    await _loadLocation();
    _startCompass();

    loading = false;
    notifyListeners();
  }

  Future<void> _loadLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        locationError = true;
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationError = true;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      qiblaData = QiblaData.fromLocation(
        position.latitude,
        position.longitude,
      );
    } catch (_) {
      locationError = true;
    }
  }

  void _startCompass() {
    try {
      _compassSubscription?.cancel();

      _compassSubscription =
          FlutterCompass.events?.listen((CompassEvent event) {
        final value = event.heading;

        if (value == null) {
          compassAvailable = false;
          notifyListeners();
          return;
        }

        compassAvailable = true;
        heading = _normalize(value);
        sensorAccuracy = event.accuracy;

        calibrationNeeded =
            sensorAccuracy != null && sensorAccuracy! < 0;

        _checkAlignment();
        notifyListeners();
      });
    } catch (_) {
      compassAvailable = false;
    }
  }

  Future<void> _checkAlignment() async {
    if (heading == null || qiblaData == null) return;

    final difference = _angularDifference(
      heading!,
      qiblaData!.bearing,
    );

    final aligned = difference <= 3;

    if (aligned && !_wasAligned) {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 300);
      }
    }

    _wasAligned = aligned;
  }

  double get qiblaDifference {
    if (heading == null || qiblaData == null) return 180;

    return _angularDifference(
      heading!,
      qiblaData!.bearing,
    );
  }

  bool get isFacingQibla => qiblaDifference <= 3;

  double get relativeQiblaAngle {
    if (heading == null || qiblaData == null) {
      return 0;
    }

    return _normalize(qiblaData!.bearing - heading!);
  }

  static double _angularDifference(double a, double b) {
    final difference = (a - b).abs() % 360;
    return difference > 180 ? 360 - difference : difference;
  }

  static double _normalize(double value) {
    var result = value % 360;
    if (result < 0) result += 360;
    return result;
  }

  void toggleDetails() {
    detailsExpanded = !detailsExpanded;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    await _loadLocation();
    notifyListeners();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}
