class QiblaService {
  Future<double> getQiblaDirection() async {
    // Qibla direction in degrees
    return 295.0;
  }

  Future<bool> isCompassAvailable() async {
    return true;
  }

  Future<String> getCurrentLocation() async {
    return "Location will be loaded here.";
  }
}
