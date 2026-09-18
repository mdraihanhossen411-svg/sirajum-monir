import '../../../core/location/location_service.dart';
import '../models/bangladesh_location.dart';
import '../models/prayer_models.dart';
import '../services/adhan_service.dart';
import 'prayer_location_controller.dart';

class PrayerController {
  final AdhanService _adhanService = AdhanService();
  final LocationService _locationService = LocationService();
  final PrayerLocationController _locationController =
      PrayerLocationController();

  Future<PrayerDayTimes> getTodayPrayerTimes({
    bool useGps = false,
  }) async {
    final now = DateTime.now();

    if (useGps) {
      final position = await _locationService.getCurrentPosition();

      if (position != null) {
        _adhanService.setLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        final times = _adhanService.getTodayPrayerTimes();

        return PrayerDayTimes(
          date: now,
          location:
              'বর্তমান অবস্থান\n'
              '${position.latitude.toStringAsFixed(4)}, '
              '${position.longitude.toStringAsFixed(4)}',
          fajr: times.fajr,
          dhuhr: times.dhuhr,
          asr: times.asr,
          maghrib: times.maghrib,
          isha: times.isha,
          sunrise: times.sunrise,
          sunset: times.sunset,
          solarNoon: times.solarNoon,
          forbiddenTimes: times.forbiddenTimes,
        );
      }
    }

    final BangladeshLocation selected =
        await _locationController.getSelectedLocation();

    _adhanService.setLocation(
      latitude: selected.latitude,
      longitude: selected.longitude,
    );

    final times = _adhanService.getTodayPrayerTimes();

    return PrayerDayTimes(
      date: now,
      location: '${selected.division} বিভাগ, ${selected.district} জেলা',
      fajr: times.fajr,
      dhuhr: times.dhuhr,
      asr: times.asr,
      maghrib: times.maghrib,
      isha: times.isha,
      sunrise: times.sunrise,
      sunset: times.sunset,
      solarNoon: times.solarNoon,
      forbiddenTimes: times.forbiddenTimes,
    );
  }

  Future<BangladeshLocation> getSelectedLocation() {
    return _locationController.getSelectedLocation();
  }

  Future<void> saveLocation(BangladeshLocation location) {
    return _locationController.saveLocation(location);
  }
}
