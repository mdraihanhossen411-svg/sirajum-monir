import 'package:flutter/material.dart';

import '../controllers/prayer_controller.dart';
import '../models/prayer_models.dart';

class PrayerTimeCard extends StatelessWidget {
  PrayerTimeCard({super.key});

  final PrayerController _controller = PrayerController();

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '${displayHour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrayerDayTimes>(
      future: _controller.getTodayPrayerTimes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0A8754),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'নামাজের সময় লোড করা যায়নি',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final prayerTimes = snapshot.data;

        if (prayerTimes == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('নামাজের সময় পাওয়া যায়নি'),
            ),
          );
        }

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.mosque,
                      color: Color(0xFF0A8754),
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'নামাজের সময়',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                _PrayerTimeRow(
                  name: prayerTimes.fajr.name,
                  time: _formatTime(prayerTimes.fajr.time),
                ),

                _PrayerTimeRow(
                  name: prayerTimes.dhuhr.name,
                  time: _formatTime(prayerTimes.dhuhr.time),
                ),

                _PrayerTimeRow(
                  name: prayerTimes.asr.name,
                  time: _formatTime(prayerTimes.asr.time),
                ),

                _PrayerTimeRow(
                  name: prayerTimes.maghrib.name,
                  time: _formatTime(prayerTimes.maghrib.time),
                ),

                _PrayerTimeRow(
                  name: prayerTimes.isha.name,
                  time: _formatTime(prayerTimes.isha.time),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;

  const _PrayerTimeRow({
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A8754),
            ),
          ),
        ],
      ),
    );
  }
}
