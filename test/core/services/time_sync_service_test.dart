import 'package:flutter_test/flutter_test.dart';
import 'package:sirajum_monir_new/core/services/time_sync_service.dart';

void main() {
  test('TimeSyncService returns a valid current time', () {
    final service = TimeSyncService.instance;

    final before = DateTime.now();
    final now = service.now();
    final after = DateTime.now();

    expect(
      now.isAfter(before.subtract(const Duration(seconds: 2))),
      isTrue,
    );

    expect(
      now.isBefore(after.add(const Duration(seconds: 2))),
      isTrue,
    );
  });
}
