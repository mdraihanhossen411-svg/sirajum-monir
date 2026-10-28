import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriPage extends StatefulWidget {
  const HijriPage({super.key});

  @override
  State<HijriPage> createState() => _HijriPageState();
}

class _HijriPageState extends State<HijriPage> {
  late HijriCalendar _currentMonth;

  static const Color _green = Color(0xFF0A8754);
  static const Color _gold = Color(0xFFC9A227);
  static const Color _blue = Color(0xFF2878B8);

  static const List<String> _weekdays = [
    'রবি',
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহঃ',
    'শুক্র',
    'শনি',
  ];

  static const List<String> _months = [
    'মুহাররম',
    'সফর',
    'রবিউল আউয়াল',
    'রবিউস সানি',
    'জমাদিউল আউয়াল',
    'জমাদিউস সানি',
    'রজব',
    'শাবান',
    'রমজান',
    'শাওয়াল',
    'জিলকদ',
    'জিলহজ',
  ];

  static const List<String> _banglaMonths = [
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

  @override
  void initState() {
    super.initState();
    _currentMonth = HijriCalendar.now();
    _setMonthLength();
  }

  void _setMonthLength() {
    _currentMonth.lengthOfMonth = _currentMonth.getDaysInMonth(
      _currentMonth.hYear,
      _currentMonth.hMonth,
    );
  }

  String _bn(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((c) {
          final i = en.indexOf(c);
          return i == -1 ? c : bn[i];
        })
        .join();
  }

  String _monthName(int month) {
    if (month < 1 || month > 12) return '';
    return _months[month - 1];
  }

  String _formatBanglaDate(DateTime date) {
    var year = date.year - 593;
    final newYear = DateTime(date.year, 4, 14);

    if (date.isBefore(newYear)) {
      year--;
    }

    final yearStart = DateTime(year + 593, 4, 14);
    final dayOfYear = date.difference(yearStart).inDays;

    final starts = <int>[
      0,
      31,
      62,
      93,
      124,
      155,
      186,
      216,
      246,
      276,
      306,
      335,
    ];

    var month = 0;

    for (var i = 0; i < starts.length; i++) {
      if (dayOfYear >= starts[i]) {
        month = i;
      } else {
        break;
      }
    }

    final day = dayOfYear - starts[month] + 1;

    return '${_bn(day)} ${_banglaMonths[month]} ${_bn(year)}';
  }

  String _formatGregorianDate(DateTime date) {
    return '${_bn(date.day)} ${_gregorianMonth(date.month)} '
        '${_bn(date.year)}';
  }

  String _gregorianMonth(int month) {
    const months = [
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

    return months[month - 1];
  }

  void _changeMonth(int offset) {
    setState(() {
      var year = _currentMonth.hYear;
      var month = _currentMonth.hMonth + offset;

      if (month < 1) {
        month = 12;
        year--;
      } else if (month > 12) {
        month = 1;
        year++;
      }

      _currentMonth = HijriCalendar.addMonth(year, month);
      _setMonthLength();
    });
  }

  void _goToday() {
    setState(() {
      _currentMonth = HijriCalendar.now();
      _setMonthLength();
    });
  }

  bool _isToday(DateTime gregorian) {
    final now = DateTime.now();

    return gregorian.year == now.year &&
        gregorian.month == now.month &&
        gregorian.day == now.day;
  }

  List<Widget> _buildDays(bool isDark) {
    final first = HijriCalendar()
      ..hYear = _currentMonth.hYear
      ..hMonth = _currentMonth.hMonth
      ..hDay = 1;

    final firstGregorian = first.hijriToGregorian(
      _currentMonth.hYear,
      _currentMonth.hMonth,
      1,
    );

    final leading = firstGregorian.weekday % 7;
    final widgets = <Widget>[];

    for (var i = 0; i < leading; i++) {
      widgets.add(const SizedBox());
    }

    for (var day = 1; day <= _currentMonth.lengthOfMonth; day++) {
      final gregorian = first.hijriToGregorian(
        _currentMonth.hYear,
        _currentMonth.hMonth,
        day,
      );

      final today = _isToday(gregorian);

      widgets.add(
        Container(
          margin: const EdgeInsets.all(2.5),
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 5,
          ),
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
                  : isDark
                      ? Colors.white10
                      : const Color(0xFFE5EDE8),
              width: today ? 1.5 : 1,
            ),
            boxShadow: today
                ? [
                    BoxShadow(
                      color: _gold.withValues(alpha: 0.25),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hijri
              Text(
                _bn(day),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: today ? _gold : _gold,
                ),
              ),
              const SizedBox(height: 2),

              // Bangla
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatBanglaDate(gregorian),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: today
                        ? Colors.white
                        : _green,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // English/Gregorian
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatGregorianDate(gregorian),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: today
                        ? Colors.white70
                        : _blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ইসলামিক ক্যালেন্ডার',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                          Color(0xFF123D2A),
                          Color(0xFF0A8754),
                        ]
                      : const [
                          Color(0xFF0A8754),
                          Color(0xFF12A66A),
                        ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.22),
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
                        icon: Icons.chevron_left_rounded,
                        onTap: () => _changeMonth(-1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.mosque_rounded,
                              color: _gold,
                              size: 25,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _monthName(_currentMonth.hMonth),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_bn(_currentMonth.hYear)} হিজরি',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _navButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => _changeMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _goToday,
                    icon: const Icon(
                      Icons.today_rounded,
                      size: 17,
                    ),
                    label: const Text('আজকের তারিখ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Legend
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF17251F)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : const Color(0xFFE5EDE8),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  _legend(_gold, 'হিজরি'),
                  _legend(_green, 'বাংলা'),
                  _legend(_blue, 'ইংরেজি'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Calendar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101B16)
                    : const Color(0xFFF9FCFA),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : const Color(0xFFE0EAE4),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: _weekdays.map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: day == 'শুক্র'
                                  ? _gold
                                  : _green,
                              fontSize: 11,
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
                    physics:
                        const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.72,
                    children: _buildDays(isDark),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Information
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF17251F)
                    : const Color(0xFFF3F8F5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: _gold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'এক নজরে হিজরি, বাংলা ও গ্রেগরিয়ান তারিখ দেখুন।',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark
                            ? Colors.white70
                            : Colors.grey.shade700,
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

  Widget _navButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
