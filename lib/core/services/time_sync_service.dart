import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TimeSyncService {
  TimeSyncService._();

  static final TimeSyncService instance = TimeSyncService._();

  static const _offsetKey = 'network_time_offset_ms';
  static const _syncKey = 'network_time_last_sync_ms';

  Duration _offset = Duration.zero;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _offset = Duration(
      milliseconds: prefs.getInt(_offsetKey) ?? 0,
    );
  }

  DateTime now() => DateTime.now().add(_offset);

  Duration get offset => _offset;

  Future<bool> sync() async {
    try {
      await initialize();

      final prefs = await SharedPreferences.getInstance();
      final lastSyncMs = prefs.getInt(_syncKey);
      if (lastSyncMs != null) {
        final elapsed = DateTime.now().toUtc().millisecondsSinceEpoch -
            lastSyncMs;
        if (elapsed >= 0 && elapsed < const Duration(hours: 6).inMilliseconds) {
          return true;
        }
      }
      final deviceBefore = DateTime.now().toUtc();

      final response = await http
          .get(
            Uri.parse(
              'https://utctime.app/api/now/Asia/Dhaka',
            ),
          )
          .timeout(const Duration(seconds: 8));

      final deviceAfter = DateTime.now().toUtc();

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);
      final unixMs = data['unix_ms'];

      if (unixMs is! num) {
        return false;
      }

      final serverTime = DateTime.fromMillisecondsSinceEpoch(
        unixMs.toInt(),
        isUtc: true,
      );

      final midpoint = deviceBefore.add(
        deviceAfter.difference(deviceBefore) ~/ 2,
      );

      _offset = serverTime.difference(midpoint);

      await prefs.setInt(
        _offsetKey,
        _offset.inMilliseconds,
      );
      await prefs.setInt(
        _syncKey,
        DateTime.now().toUtc().millisecondsSinceEpoch,
      );

      return true;
    } catch (_) {
      return false;
    }
  }


  Future<DateTime> syncedNow() async {
    await initialize();
    await sync();
    return now();
  }

  static String encodeDebug(DateTime value) {
    return jsonEncode({
      'utc': value.toUtc().toIso8601String(),
      'offsetMs': instance.offset.inMilliseconds,
    });
  }
}
