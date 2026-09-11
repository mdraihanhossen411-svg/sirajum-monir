import 'package:flutter/material.dart';
import '../controllers/prayer_controller.dart';
import '../models/prayer_models.dart';

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '${displayHour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')} $period';
  }

  PrayerTime _getNextPrayer(PrayerDayTimes times) {
    final now = DateTime.now();

    final prayers = [
      times.fajr,
      times.dhuhr,
      times.asr,
      times.maghrib,
      times.isha,
    ];

    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }

    // সব নামাজ হয়ে গেলে আগামী দিনের ফজর দেখাবে
    return PrayerTime(
      name: 'ফজর',
      time: times.fajr.time.add(const Duration(days: 1)),
    );
  }


  @override
  Widget build(BuildContext context) {
    final controller = PrayerController();
    final prayerTimes = controller.getTodayPrayerTimes();
    final nextPrayer = _getNextPrayer(prayerTimes);

    return Scaffold(
      appBar: AppBar(
        title: const Text("নামাজের সময়"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's prayer time
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Color(0xFF0A8754),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "আজকের নামাজের সময়",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF0A8754),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          prayerTimes.location,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Next prayer
            Card(
              elevation: 3,
              color: const Color(0xFFE8F5E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF0A8754),
                      size: 35,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "পরবর্তী নামাজ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nextPrayer.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(nextPrayer.time),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A8754),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "৫ ওয়াক্ত নামাজ",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _PrayerTimeCard(
              icon: Icons.wb_twilight,
              prayer: prayerTimes.fajr,
              formatTime: _formatTime,
            ),

            _PrayerTimeCard(
              icon: Icons.wb_sunny,
              prayer: prayerTimes.dhuhr,
              formatTime: _formatTime,
            ),

            _PrayerTimeCard(
              icon: Icons.sunny,
              prayer: prayerTimes.asr,
              formatTime: _formatTime,
            ),

            _PrayerTimeCard(
              icon: Icons.wb_twilight,
              prayer: prayerTimes.maghrib,
              formatTime: _formatTime,
            ),

            _PrayerTimeCard(
              icon: Icons.nightlight_round,
              prayer: prayerTimes.isha,
              formatTime: _formatTime,
            ),

            const SizedBox(height: 20),

            // Sunrise
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFF0A8754),
                  size: 30,
                ),
                title: const Text(
                  "সূর্যোদয়",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  _formatTime(prayerTimes.sunrise.time),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Information
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF0A8754),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "নামাজের সময় স্থান ও তারিখ অনুযায়ী পরিবর্তিত হয়। "
                            "পরবর্তী ধাপে আপনার অবস্থান অনুযায়ী সঠিক সময় "
                            "দেখানোর ব্যবস্থা করা হবে।",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerTimeCard extends StatelessWidget {
  final IconData icon;
  final PrayerTime prayer;
  final String Function(DateTime) formatTime;

  const _PrayerTimeCard({
    required this.icon,
    required this.prayer,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF0A8754),
          size: 30,
        ),
        title: Text(
          prayer.name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          formatTime(prayer.time),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A8754),
          ),
        ),
      ),
    );
  }
}