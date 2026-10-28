import 'package:flutter_test/flutter_test.dart';
import 'package:sirajum_monir_new/core/utils/date_utils.dart';

void main() {
  group('BanglaCalendarService', () {
    test('নববর্ষের আগের দিন ও নববর্ষ', () {
      final before = BanglaCalendarService.fromGregorian(DateTime(2026, 4, 13));
      final newYear = BanglaCalendarService.fromGregorian(
        DateTime(2026, 4, 14),
      );

      expect((before.year, before.month, before.day), (1432, 12, 30));
      expect((newYear.year, newYear.month, newYear.day), (1433, 1, 1));
    });

    test('জাতীয় দিবসের বাংলা তারিখ', () {
      final languageDay = BanglaCalendarService.fromGregorian(
        DateTime(2026, 2, 21),
      );
      final independenceDay = BanglaCalendarService.fromGregorian(
        DateTime(2026, 3, 26),
      );
      final victoryDay = BanglaCalendarService.fromGregorian(
        DateTime(2026, 12, 16),
      );

      expect(
        (languageDay.year, languageDay.month, languageDay.day),
        (1432, 11, 8),
      );
      expect(
        (independenceDay.year, independenceDay.month, independenceDay.day),
        (1432, 12, 12),
      );
      expect((victoryDay.year, victoryDay.month, victoryDay.day), (1433, 9, 1));
    });

    test('গ্রেগরিয়ান অধিবর্ষে ফাল্গুন ৩০ দিন', () {
      final first = BanglaCalendarService.fromGregorian(DateTime(2028, 2, 14));
      final last = BanglaCalendarService.fromGregorian(DateTime(2028, 3, 14));
      final nextMonth = BanglaCalendarService.fromGregorian(
        DateTime(2028, 3, 15),
      );

      expect((first.year, first.month, first.day), (1434, 11, 1));
      expect((last.year, last.month, last.day), (1434, 11, 30));
      expect((nextMonth.year, nextMonth.month, nextMonth.day), (1434, 12, 1));
      expect(BanglaCalendarService.daysInMonth(1434, 11), 30);
    });

    test('বাংলা থেকে Gregorian তারিখে রূপান্তর', () {
      expect(
        BanglaCalendarService.toGregorian(1433, 1, 1),
        DateTime(2026, 4, 14),
      );
      expect(
        BanglaCalendarService.toGregorian(1434, 11, 30),
        DateTime(2028, 3, 14),
      );
    });

    test('২০২৫–২০৩০ সালের প্রতিটি দিনের round-trip', () {
      for (var year = 2025; year <= 2030; year++) {
        var date = DateTime(year, 1, 1);
        final end = DateTime(year + 1, 1, 1);

        while (date.isBefore(end)) {
          final bangla = BanglaCalendarService.fromGregorian(date);
          final converted = BanglaCalendarService.toGregorian(
            bangla.year,
            bangla.month,
            bangla.day,
          );

          expect(converted, date, reason: 'রূপান্তর ব্যর্থ: $date');
          date = date.add(const Duration(days: 1));
        }
      }
    });
  });
}
