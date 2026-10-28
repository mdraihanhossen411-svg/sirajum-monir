import 'dart:math' as math;

class QiblaData {
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  final double latitude;
  final double longitude;
  final double bearing;
  final double distanceKm;

  const QiblaData({
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.distanceKm,
  });

  static QiblaData fromLocation(double latitude, double longitude) {
    final lat1 = _rad(latitude);
    final lat2 = _rad(kaabaLatitude);
    final dLon = _rad(kaabaLongitude - longitude);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    var bearing = _deg(math.atan2(y, x));
    if (bearing < 0) bearing += 360;

    const earthRadiusKm = 6371.0088;
    final dLat = lat2 - lat1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distanceKm = earthRadiusKm * c;

    return QiblaData(
      latitude: latitude,
      longitude: longitude,
      bearing: bearing,
      distanceKm: distanceKm,
    );
  }

  static double _rad(double value) => value * math.pi / 180;
  static double _deg(double value) => value * 180 / math.pi;
}

String directionFromDegrees(double degrees) {
  const directions = <String>[
    'উত্তর',
    'উত্তর-পূর্ব',
    'পূর্ব',
    'দক্ষিণ-পূর্ব',
    'দক্ষিণ',
    'দক্ষিণ-পশ্চিম',
    'পশ্চিম',
    'উত্তর-পশ্চিম',
  ];

  final index = ((degrees + 22.5) / 45).floor() % 8;
  return directions[index];
}

String shortDirectionFromDegrees(double degrees) {
  const directions = <String>[
    'N',
    'NE',
    'E',
    'SE',
    'S',
    'SW',
    'W',
    'NW',
  ];

  final index = ((degrees + 22.5) / 45).floor() % 8;
  return directions[index];
}
