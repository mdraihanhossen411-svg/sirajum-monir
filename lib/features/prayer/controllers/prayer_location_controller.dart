import 'package:shared_preferences/shared_preferences.dart';

import '../data/bangladesh_locations.dart';
import '../models/bangladesh_location.dart';

class PrayerLocationController {
  static const String _divisionKey = 'prayer_division';
  static const String _districtKey = 'prayer_district';

  Future<BangladeshLocation> getSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final division =
        prefs.getString(_divisionKey) ?? 'ঢাকা';
    final district =
        prefs.getString(_districtKey) ?? 'ঢাকা';

    return BangladeshLocations.find(division, district) ??
        BangladeshLocations.all.first;
  }

  Future<void> saveLocation(BangladeshLocation location) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _divisionKey,
      location.division,
    );

    await prefs.setString(
      _districtKey,
      location.district,
    );
  }

  Future<String> getSelectedDivision() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_divisionKey) ?? 'ঢাকা';
  }

  Future<String> getSelectedDistrict() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_districtKey) ?? 'ঢাকা';
  }
}
