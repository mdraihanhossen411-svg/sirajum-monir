import 'package:flutter/material.dart';

import '../../prayer/controllers/prayer_controller.dart';
import '../../prayer/models/prayer_models.dart';

class RamadanPage extends StatefulWidget {
  const RamadanPage({super.key});

  @override
  State<RamadanPage> createState() => _RamadanPageState();
}

class _RamadanPageState extends State<RamadanPage> {
  final PrayerController _controller = PrayerController();
  late Future<PrayerDayTimes> _timesFuture;

  static const _green = Color(0xFF087A3B);
  static const _gold = Color(0xFFC9A227);

  @override
  void initState() {
    super.initState();
    _timesFuture = _controller.getTodayPrayerTimes();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  String _date(DateTime date) {
    const weekdays = [
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার',
      'রবিবার',
    ];
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
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _timeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _green.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _green, size: 28),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: _green,
              ),
            ),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String body, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: _gold, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(body, style: const TextStyle(height: 1.6)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('রমজান'),
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PrayerDayTimes>(
        future: _timesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 42),
                    const SizedBox(height: 12),
                    const Text('নামাজের সময় আনা যায়নি।'),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => setState(
                        () => _timesFuture = _controller.getTodayPrayerTimes(),
                      ),
                      child: const Text('আবার চেষ্টা করুন'),
                    ),
                  ],
                ),
              ),
            );
          }

          final times = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [_green, Color(0xFF063B25)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.nightlight_round, color: _gold, size: 34),
                    SizedBox(height: 10),
                    Text(
                      'রমজান মোবারক',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'রহমত, মাগফিরাত ও নাজাতের মাস',
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _date(DateTime.now()),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'সময়সূচি: ${times.location}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timeTile(
                    icon: Icons.wb_twilight,
                    title: 'সাহরির শেষ',
                    subtitle: 'ফজর শুরু',
                    time: _formatTime(times.fajr.time),
                  ),
                  const SizedBox(width: 12),
                  _timeTile(
                    icon: Icons.wb_sunny_outlined,
                    title: 'ইফতার',
                    subtitle: 'মাগরিব শুরু',
                    time: _formatTime(times.maghrib.time),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'সময়গুলো নির্বাচিত অবস্থানের হিসাব অনুযায়ী। রোজার দিন নিশ্চিত করে সময়সূচি অনুসরণ করুন।',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              _infoCard(
                'রোজার নিয়ত',
                'নিয়ত মূলত অন্তরের সংকল্প। মুখে নির্দিষ্ট বাক্য বলা রোজার শর্ত নয়।',
                Icons.favorite_border,
              ),
              _infoCard(
                'ইফতারের সময় দোয়া',
                'ইফতারের আগে ও সময়ে আল্লাহর কাছে দোয়া করুন। প্রচলিত দোয়ার বর্ণনা ও গ্রহণযোগ্যতা যাচাই করে আমল করুন।',
                Icons.volunteer_activism_outlined,
              ),
              _infoCard(
                'রমজানের আমল',
                'পাঁচ ওয়াক্ত নামাজ, কুরআন তিলাওয়াত, দান-সাদাকাহ, আত্মসংযম এবং মানুষের হক আদায়ে গুরুত্ব দিন।',
                Icons.auto_awesome,
              ),
            ],
          );
        },
      ),
    );
  }
}
