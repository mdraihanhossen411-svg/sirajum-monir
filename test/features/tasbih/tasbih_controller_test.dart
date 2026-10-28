import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../lib/features/tasbih/controllers/tasbih_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TasbihController', () {
    late TasbihController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = TasbihController();
      await controller.init();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is correct', () {
      expect(controller.count, 0);
      expect(controller.target, 33);
      expect(controller.todayCount, 0);
    });

    test('increment increases counter and daily count', () async {
      await controller.increment();
      await controller.increment();
      await controller.increment();

      expect(controller.count, 3);
      expect(controller.todayCount, 3);
      expect(controller.todayTotal, 3);
    });

    test('undo restores previous count and daily count', () async {
      await controller.increment();
      await controller.increment();

      expect(controller.count, 2);
      expect(controller.todayCount, 2);

      await controller.undo();

      expect(controller.count, 1);
      expect(controller.todayCount, 1);
    });

    test('reset clears current counter but keeps today history', () async {
      await controller.increment();
      await controller.increment();
      await controller.increment();

      expect(controller.count, 3);
      expect(controller.todayCount, 3);

      await controller.reset();

      expect(controller.count, 0);
      expect(controller.todayCount, 3);
      expect(controller.todayTotal, 3);
    });

    test('target prevents counter from exceeding target', () async {
      await controller.setTarget(3);

      await controller.increment();
      await controller.increment();
      await controller.increment();
      await controller.increment();

      expect(controller.count, 3);
      expect(controller.todayCount, 3);
    });

    test('daily history contains today count', () async {
      await controller.increment();
      await controller.increment();

      final history = await controller.getDailyHistory();

      expect(history, isNotEmpty);
      expect(history.first['total'], 2);
    });

    test('daily history can be cleared without resetting counter', () async {
    final controller = TasbihController();
    await controller.init();

    await controller.increment();

    final before = await controller.getDailyHistory();
    expect(before, isNotEmpty);
    expect(controller.count, 1);

    await controller.clearDailyHistory();

    final after = await controller.getDailyHistory();
    expect(after, isEmpty);
    expect(controller.count, 1);

    controller.dispose();
  });

  test('counter persists after controller reload', () async {
      await controller.increment();
      await controller.increment();

      final secondController = TasbihController();
      await secondController.init();

      expect(secondController.count, 2);
      expect(secondController.todayCount, 2);

      secondController.dispose();
    });
  });
}
