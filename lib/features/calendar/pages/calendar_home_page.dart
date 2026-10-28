import 'package:flutter/material.dart';
import 'my_events_page.dart';
import '../../../core/utils/date_utils.dart';
import 'bangla_calendar_page.dart';
import 'date_converter_page.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../hijri/pages/hijri_page.dart';

class CalendarHomePage extends StatelessWidget {
  const CalendarHomePage({super.key});

  static const Color _green = Color(0xFF0A8754);
  static const Color _darkGreen = Color(0xFF075C3A);
  static const Color _gold = Color(0xFFC9A227);
  static const Color _blue = Color(0xFF2878B8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ইসলামিক ক্যালেন্ডার',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF0D1B15), Color(0xFF101A16)]
                : const [Color(0xFFF5FAF7), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroCard(isDark, now),
              const SizedBox(height: 10),
              _quranCard(isDark),
              const SizedBox(height: 18),

              _sectionTitle('ক্যালেন্ডার', 'তিনটি ক্যালেন্ডার আলাদাভাবে দেখুন'),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _calendarCard(
                      context,
                      icon: Icons.mosque_rounded,
                      title: 'হিজরি',
                      subtitle: 'ইসলামিক ক্যালেন্ডার',
                      color: _gold,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _calendarCard(
                      context,
                      icon: Icons.flag_rounded,
                      title: 'বাংলা',
                      subtitle: 'বাংলা বর্ষপঞ্জি',
                      color: _green,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _wideFeature(
                context,
                icon: Icons.calendar_month_rounded,
                title: 'ইংরেজি ক্যালেন্ডার',
                subtitle: 'Gregorian Calendar',
                color: _blue,
                isDark: isDark,
              ),

              const SizedBox(height: 18),

              _sectionTitle('দ্রুত ফিচার', 'ক্যালেন্ডারের প্রয়োজনীয় সুবিধা'),

              const SizedBox(height: 10),

              _featureTile(
                context,
                Icons.sync_alt_rounded,
                'তারিখ রূপান্তর',
                'হিজরি • বাংলা • Gregorian',
                _gold,
                isDark,
              ),

              _featureTile(
                context,
                Icons.nightlight_round,
                'ইসলামিক মাস',
                'হিজরি মাসের দিন ও তথ্য',
                _green,
                isDark,
              ),

              _featureTile(
                context,
                Icons.star_rounded,
                'গুরুত্বপূর্ণ ইসলামিক দিন',
                'বিশেষ দিন ও তারিখ',
                _gold,
                isDark,
              ),

              _featureTile(
                context,
                Icons.book_rounded,
                'কুরআন ও সময়',
                'সময় ও হিসাব সম্পর্কিত কুরআনের আয়াত',
                _blue,
                isDark,
              ),

              _featureTile(
                context,
                Icons.event_note_rounded,
                'আমার ইভেন্ট',
                'ব্যক্তিগত তারিখ ও স্মরণিকা',
                _green,
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroCard(bool isDark, DateTime now) {
    final hijri = HijriCalendar.fromDate(now);

    final hijriMonths = [
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

    final hijriDate =
        '${_bn(hijri.hDay)} ${hijriMonths[hijri.hMonth - 1]} '
        '${_bn(hijri.hYear)} হিজরি';

    final banglaDate = _banglaDate(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_darkGreen, _green],
        ),
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.nightlight_round, color: _gold, size: 20),
              SizedBox(width: 7),
              Text(
                'আজকের তারিখ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),

          // Hijri
          _todayDateRow(
            icon: Icons.mosque_rounded,
            label: 'হিজরি',
            date: hijriDate,
            color: _gold,
          ),

          const SizedBox(height: 7),

          // Bangla
          _todayDateRow(
            icon: Icons.flag_rounded,
            label: 'বাংলা',
            date: banglaDate,
            color: Colors.white,
          ),

          const SizedBox(height: 7),

          // Gregorian
          _todayDateRow(
            icon: Icons.calendar_month_rounded,
            label: 'ইংরেজি',
            date:
                '${_bn(now.day)} ${_gregorianMonth(now.month)} ${_bn(now.year)}',
            color: const Color(0xFF8FD0FF),
          ),

          const SizedBox(height: 9),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _weekday(now.weekday),
              style: const TextStyle(
                color: _gold,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todayDateRow({
    required IconData icon,
    required String label,
    required String date,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.70),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            date,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  String _banglaDate(DateTime date) {
    final info = BanglaCalendarService.fromGregorian(date);
    return '${_bn(info.day)} '
        '${BanglaCalendarService.months[info.month - 1]} '
        '${_bn(info.year)} বঙ্গাব্দ';
  }

  Widget _calendarCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return _card(
      isDark,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: title == 'হিজরি'
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HijriPage()),
                );
              }
            : title == 'বাংলা'
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BanglaCalendarPage()),
                );
              }
            : () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _iconCircle(icon, color),
              const SizedBox(height: 9),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wideFeature(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return _card(
      isDark,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          if (title == 'ইংরেজি ক্যালেন্ডার') {
            await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              helpText: 'তারিখ নির্বাচন করুন',
              cancelText: 'বাতিল',
              confirmText: 'নির্বাচন',
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              _iconCircle(icon, color),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: color.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _card(
        isDark,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 2,
          ),
          leading: _iconCircle(icon, color, size: 42),
          title: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey.shade900,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              fontSize: 10.5,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: color),
          onTap: () {
            if (title == 'তারিখ রূপান্তর') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DateConverterPage()),
              );
            } else if (title == 'আমার ইভেন্ট') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyEventsPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('এই সুবিধাটি এখনো প্রস্তুত করা হয়নি।'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _quranCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF17271F) : const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: _gold, size: 24),
          const SizedBox(height: 8),
          const Text(
            'هُوَ ٱلَّذِى جَعَلَ ٱلشَّمْسَ ضِيَآءًۭ وَٱلْقَمَرَ نُورًۭا وَقَدَّرَهُۥ مَنَازِلَ لِّتَعْلَمُوا۟ عَدَدَ ٱلسِّنِينَ وَٱلْحِسَابَ',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: _gold,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'তিনি সূর্যকে করেছেন তেজোদীপ্ত, আর চন্দ্রকে করেছেন আলোকময় এবং তার মানযিলসমূহ নির্ধারণ করেছেন, যাতে তোমরা বছর ও সময়ের হিসাব জানতে পার।',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'সূরা ইউনুস — ১০:৫',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 34,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF17251F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2EAE5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _iconCircle(IconData icon, Color color, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }

  String _bn(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number.toString().split('').map((c) {
      final i = en.indexOf(c);
      return i == -1 ? c : bn[i];
    }).join();
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

  String _weekday(int weekday) {
    const days = [
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার',
      'রবিবার',
    ];

    return days[weekday - 1];
  }
}
