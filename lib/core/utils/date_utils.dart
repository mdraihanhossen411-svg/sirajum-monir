class BanglaDateInfo {
  final int year;
  final int month;
  final int day;

  const BanglaDateInfo({
    required this.year,
    required this.month,
    required this.day,
  });
}

/// বাংলাদেশের সংশোধিত বাংলা পঞ্জিকার গণনা।
/// নববর্ষ ১৪ এপ্রিল; বৈশাখ–আশ্বিন ৩১ দিন,
/// কার্তিক–মাঘ ৩০ দিন, ফাল্গুন ২৯/৩০ দিন, চৈত্র ৩০ দিন।
class BanglaCalendarService {
  const BanglaCalendarService._();

  static const List<String> months = [
    'বৈশাখ',
    'জ্যৈষ্ঠ',
    'আষাঢ়',
    'শ্রাবণ',
    'ভাদ্র',
    'আশ্বিন',
    'কার্তিক',
    'অগ্রহায়ণ',
    'পৌষ',
    'মাঘ',
    'ফাল্গুন',
    'চৈত্র',
  ];

  static bool _isLeapYear(int year) =>
      year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);

  static int daysInMonth(int banglaYear, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'বাংলা মাস ১–১২ হতে হবে');
    }
    if (month <= 6) return 31;
    if (month <= 10) return 30;
    if (month == 11) return _isLeapYear(banglaYear + 594) ? 30 : 29;
    return 30;
  }

  static DateTime yearStart(int banglaYear) =>
      DateTime(banglaYear + 593, 4, 14);

  static BanglaDateInfo fromGregorian(DateTime input) {
    final date = DateTime(input.year, input.month, input.day);
    final april14 = DateTime(date.year, 4, 14);
    final year = date.isBefore(april14) ? date.year - 594 : date.year - 593;

    var remaining = date.difference(yearStart(year)).inDays;
    for (var month = 1; month <= 12; month++) {
      final length = daysInMonth(year, month);
      if (remaining < length) {
        return BanglaDateInfo(year: year, month: month, day: remaining + 1);
      }
      remaining -= length;
    }
    throw StateError('বাংলা তারিখ গণনা করা যায়নি।');
  }

  static DateTime toGregorian(int year, int month, int day) {
    final maxDay = daysInMonth(year, month);
    if (day < 1 || day > maxDay) {
      throw ArgumentError.value(day, 'day', 'বাংলা দিনের সংখ্যা সঠিক নয়');
    }

    var offset = day - 1;
    for (var m = 1; m < month; m++) {
      offset += daysInMonth(year, m);
    }
    return yearStart(year).add(Duration(days: offset));
  }
}
