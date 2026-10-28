import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import 'package:hijri/hijri_calendar.dart';

enum _CalendarSource { gregorian, bangla, hijri }

class DateConverterPage extends StatefulWidget {
  const DateConverterPage({super.key});

  @override
  State<DateConverterPage> createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  static const Color _green = Color(0xFF0A8754);
  static const Color _gold = Color(0xFFC9A227);

  DateTime _selectedDate = DateTime.now();
  _CalendarSource _source = _CalendarSource.gregorian;

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

  static const List<String> _gregorianMonths = [
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

  static const List<String> _hijriMonths = [
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

  static const List<String> _weekdays = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
  ];

  String _bn(int value) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';
    return value.toString().split('').map((c) {
      final index = en.indexOf(c);
      return index < 0 ? c : bn[index];
    }).join();
  }

  int _daysInBanglaMonth(int year, int month) =>
      BanglaCalendarService.daysInMonth(year, month);

  ({int year, int month, int day}) _banglaFromGregorian(DateTime date) {
    final info = BanglaCalendarService.fromGregorian(date);
    return (year: info.year, month: info.month, day: info.day);
  }

  DateTime _gregorianFromBangla(int year, int month, int day) =>
      BanglaCalendarService.toGregorian(year, month, day);

  DateTime _gregorianFromHijri(int year, int month, int day) {
    final converted = HijriCalendar().hijriToGregorian(year, month, day);
    return DateTime(converted.year, converted.month, converted.day);
  }

  String _sourceLabel(_CalendarSource source) {
    switch (source) {
      case _CalendarSource.gregorian:
        return 'ইংরেজি ক্যালেন্ডার';
      case _CalendarSource.bangla:
        return 'বাংলা ক্যালেন্ডার';
      case _CalendarSource.hijri:
        return 'হিজরি ক্যালেন্ডার';
    }
  }

  String _gregorianDate(DateTime date) =>
      '${_bn(date.day)} ${_gregorianMonths[date.month - 1]} ${_bn(date.year)}';

  String _banglaDate(DateTime date) {
    final info = _banglaFromGregorian(date);
    return '${_bn(info.day)} ${_banglaMonths[info.month - 1]} '
        '${_bn(info.year)} বঙ্গাব্দ';
  }

  String _hijriDate(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    final monthName = hijri.hMonth >= 1 && hijri.hMonth <= 12
        ? _hijriMonths[hijri.hMonth - 1]
        : hijri.getLongMonthName();

    return '${_bn(hijri.hDay)} $monthName ${_bn(hijri.hYear)} হিজরি';
  }

  Future<void> _pickGregorianDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'ইংরেজি তারিখ নির্বাচন করুন',
      cancelText: 'বাতিল',
      confirmText: 'নির্বাচন',
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickBanglaDate() async {
    final current = _banglaFromGregorian(_selectedDate);
    var year = current.year;
    var month = current.month;
    var day = current.day;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final days = _daysInBanglaMonth(year, month);
          final safeDay = day > days ? days : day;

          return AlertDialog(
            title: const Text('বাংলা তারিখ নির্বাচন'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: year,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'বঙ্গাব্দ'),
                  items: List.generate(201, (i) => year - 100 + i)
                      .map(
                        (y) => DropdownMenuItem(value: y, child: Text(_bn(y))),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      year = value;
                      final maxDay = _daysInBanglaMonth(year, month);
                      if (day > maxDay) day = maxDay;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  initialValue: month,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'মাস'),
                  items: List.generate(12, (i) => i + 1)
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(_banglaMonths[m - 1]),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      month = value;
                      final maxDay = _daysInBanglaMonth(year, month);
                      if (day > maxDay) day = maxDay;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  initialValue: safeDay,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'দিন'),
                  items: List.generate(days, (i) => i + 1)
                      .map(
                        (d) => DropdownMenuItem(value: d, child: Text(_bn(d))),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => day = value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('বাতিল'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _gregorianFromBangla(year, month, safeDay),
                ),
                child: const Text('নির্বাচন'),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      setState(() => _selectedDate = result);
    }
  }

  Future<void> _pickHijriDate() async {
    final current = HijriCalendar.fromDate(_selectedDate);
    var year = current.hYear;
    var month = current.hMonth;
    var day = current.hDay;

    int daysInMonth(int y, int m) => HijriCalendar.addMonth(y, m).lengthOfMonth;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final days = daysInMonth(year, month);
          final safeDay = day > days ? days : day;

          return AlertDialog(
            title: const Text('হিজরি তারিখ নির্বাচন'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: year,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'হিজরি বছর'),
                  items: List.generate(201, (i) => year - 100 + i)
                      .map(
                        (y) => DropdownMenuItem(value: y, child: Text(_bn(y))),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      year = value;
                      final maxDay = daysInMonth(year, month);
                      if (day > maxDay) day = maxDay;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  initialValue: month,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'হিজরি মাস'),
                  items: List.generate(12, (i) => i + 1)
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(_hijriMonths[m - 1]),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      month = value;
                      final maxDay = daysInMonth(year, month);
                      if (day > maxDay) day = maxDay;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  initialValue: day,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'দিন'),
                  items: List.generate(days, (i) => i + 1)
                      .map(
                        (d) => DropdownMenuItem(value: d, child: Text(_bn(d))),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => day = value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('বাতিল'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _gregorianFromHijri(year, month, safeDay),
                ),
                child: const Text('নির্বাচন'),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      setState(() => _selectedDate = result);
    }
  }

  Future<void> _pickSelectedDate() async {
    switch (_source) {
      case _CalendarSource.gregorian:
        await _pickGregorianDate();
      case _CalendarSource.bangla:
        await _pickBanglaDate();
      case _CalendarSource.hijri:
        await _pickHijriDate();
    }
  }

  Widget _dateCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('তারিখ রূপান্তর'),
        centerTitle: true,
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: _green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: _gold,
                    size: 42,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ক্যালেন্ডার নির্বাচন করুন',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<_CalendarSource>(
                    initialValue: _source,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _CalendarSource.values
                        .map(
                          (source) => DropdownMenuItem(
                            value: source,
                            child: Text(_sourceLabel(source)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _source = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'নির্বাচিত তারিখ: ${_sourceLabel(_source)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _pickSelectedDate,
                    icon: const Icon(Icons.edit_calendar_rounded),
                    label: const Text('দিন, মাস ও বছর নির্বাচন করুন'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _dateCard(
            icon: Icons.mosque_rounded,
            title: 'হিজরি তারিখ',
            value: _hijriDate(_selectedDate),
            color: _gold,
          ),
          _dateCard(
            icon: Icons.flag_rounded,
            title: 'বাংলা তারিখ',
            value: _banglaDate(_selectedDate),
            color: _green,
          ),
          _dateCard(
            icon: Icons.public_rounded,
            title: 'ইংরেজি / Gregorian',
            value: _gregorianDate(_selectedDate),
            color: Colors.blue,
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              _weekdays[_selectedDate.weekday - 1],
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'নোট: হিজরি তারিখ লাইব্রেরির গণনাভিত্তিক। '
            'বাংলাদেশের সরকারি চাঁদ দেখার ঘোষণার সঙ্গে পার্থক্য হতে পারে।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
