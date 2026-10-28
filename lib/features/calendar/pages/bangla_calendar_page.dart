import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';

class BanglaCalendarPage extends StatefulWidget {
  const BanglaCalendarPage({super.key});

  @override
  State<BanglaCalendarPage> createState() => _BanglaCalendarPageState();
}

class _BanglaCalendarPageState extends State<BanglaCalendarPage> {
  static const Color _green = Color(0xFF0A8754);
  static const Color _gold = Color(0xFFC9A227);

  static const List<String> _months = [
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

  static const List<String> _weekdays = [
    'রবি',
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহঃ',
    'শুক্র',
    'শনি',
  ];

  int _month = 1;
  late int _year;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final info = _banglaFromGregorian(now);

    _year = info.year;
    _month = info.month;
  }

  int _daysInMonth(int year, int month) =>
      BanglaCalendarService.daysInMonth(year, month);

  DateTime _gregorianFromBangla(int year, int month, int day) =>
      BanglaCalendarService.toGregorian(year, month, day);

  _BanglaDate _banglaFromGregorian(DateTime date) {
    final info = BanglaCalendarService.fromGregorian(date);
    return _BanglaDate(year: info.year, month: info.month, day: info.day);
  }

  void _changeMonth(int offset) {
    setState(() {
      _month += offset;

      if (_month < 1) {
        _month = 12;
        _year--;
      } else if (_month > 12) {
        _month = 1;
        _year++;
      }
    });
  }

  void _goToday() {
    final info = _banglaFromGregorian(DateTime.now());

    setState(() {
      _year = info.year;
      _month = info.month;
    });
  }

  String _bn(int value) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return value.toString().split('').map((c) {
      final i = en.indexOf(c);
      return i == -1 ? c : bn[i];
    }).join();
  }

  String _gregorianMonth(int month) {
    const names = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];

    return names[month - 1];
  }

  String _weekdayLong(int weekday) {
    const names = [
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার',
      'রবিবার',
    ];

    return names[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final days = _daysInMonth(_year, _month);
    final firstGregorian = _gregorianFromBangla(_year, _month, 1);

    final leading = firstGregorian.weekday % 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'বাংলা ক্যালেন্ডার',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF075C3A), _green],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _navButton(
                        Icons.chevron_left_rounded,
                        () => _changeMonth(-1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: _gold,
                              size: 27,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _months[_month - 1],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${_bn(_year)} বঙ্গাব্দ',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _navButton(
                        Icons.chevron_right_rounded,
                        () => _changeMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  OutlinedButton.icon(
                    onPressed: _goToday,
                    icon: const Icon(Icons.today_rounded, size: 17),
                    label: const Text('আজকের তারিখ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.40),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF17251F) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE1EAE5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_bn(days)} দিন',
                    style: const TextStyle(
                      color: _green,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${_gregorianMonth(firstGregorian.month)} '
                    '${_bn(firstGregorian.year)}',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101B16)
                    : const Color(0xFFF9FCFA),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE0EAE4),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: _weekdays.map((day) {
                      final friday = day == 'শুক্র';

                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: friday ? _gold : _green,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.95,
                    children: [
                      ...List.generate(leading, (_) => const SizedBox()),
                      ...List.generate(days, (index) {
                        final day = index + 1;
                        final date = _gregorianFromBangla(_year, _month, day);

                        final now = DateTime.now();
                        final today =
                            date.year == now.year &&
                            date.month == now.month &&
                            date.day == now.day;

                        final friday = date.weekday == DateTime.friday;

                        return Container(
                          margin: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: today
                                ? _green
                                : isDark
                                ? const Color(0xFF17251F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: today
                                  ? _gold
                                  : friday
                                  ? _gold.withValues(alpha: 0.45)
                                  : isDark
                                  ? Colors.white10
                                  : const Color(0xFFE5EDE8),
                              width: today ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _bn(day),
                                style: TextStyle(
                                  color: today ? _gold : _green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_bn(date.day)} '
                                '${_gregorianMonth(date.month)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: today
                                      ? Colors.white
                                      : isDark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                  fontSize: 7.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _weekdayLong(date.weekday),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: friday
                                      ? _gold
                                      : today
                                      ? Colors.white70
                                      : isDark
                                      ? Colors.white38
                                      : Colors.grey.shade500,
                                  fontSize: 6.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF17251F)
                    : const Color(0xFFF3F8F5),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: _gold,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'বাংলাদেশের সংশোধিত বাংলা একাডেমি '
                      'ক্যালেন্ডার অনুযায়ী বাংলা তারিখ দেখানো হচ্ছে।',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _BanglaDate {
  final int year;
  final int month;
  final int day;

  const _BanglaDate({
    required this.year,
    required this.month,
    required this.day,
  });
}
