import 'package:flutter/material.dart';

import '../controllers/qibla_controller.dart';
import '../models/qibla_models.dart';
import '../../prayer/data/bangladesh_locations.dart';
import '../../prayer/models/bangladesh_location.dart';
import '../widgets/compass_widget.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  late final QiblaController controller;

  @override
  void initState() {
    super.initState();
    controller = QiblaController();
    controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  BangladeshLocation? _nearestBangladeshLocation(QiblaData data) {
    BangladeshLocation? nearest;
    double best = double.infinity;

    for (final location in BangladeshLocations.all) {
      final dLat = data.latitude - location.latitude;
      final dLon = data.longitude - location.longitude;
      final distance = dLat * dLat + dLon * dLon;

      if (distance < best) {
        best = distance;
        nearest = location;
      }
    }

    return nearest;
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.qiblaData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কিবলা কম্পাস'),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0D1B14)
            : const Color(0xFF087A3B),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'কিবলা সম্পর্কে',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showQiblaInfo(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshLocation,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
            children: [

              if (controller.loading)
                const SizedBox(
                  height: 430,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (data == null)
                _locationError(context)
              else ...[
                _degreeHeader(data),
                const SizedBox(height: 8),

                CompassWidget(
                  heading: controller.heading ?? 0.0,
                  qiblaBearing: data.bearing,
                  isFacingQibla: controller.isFacingQibla,
                ),

                const SizedBox(height: 8),
                _statusCard(context, data),

                const SizedBox(height: 8),
                _infoCard(context, data),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showQiblaInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final dark = Theme.of(sheetContext).brightness == Brightness.dark;
        final bg = dark ? const Color(0xFF0D1B14) : Colors.white;
        final surface = dark ? const Color(0xFF17271E) : const Color(0xFFF5F8F6);
        final textColor = dark ? Colors.white : const Color(0xFF183026);
        final muted = dark ? Colors.white70 : const Color(0xFF52665D);

        return DraggableScrollableSheet(
          initialChildSize: .82,
          minChildSize: .55,
          maxChildSize: .95,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: muted.withValues(alpha: .35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF087A3B),
                          const Color(0xFF0D5E34),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A227).withValues(alpha: .18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFC9A227).withValues(alpha: .55),
                            ),
                          ),
                          child: const Icon(
                            Icons.mosque_rounded,
                            color: Color(0xFFC9A227),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'কিবলা সম্পর্কে',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'কাবা শরিফের দিক ও কিবলার গুরুত্ব',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: .82),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.mosque_rounded,
                    'কিবলা কী?',
                    'কিবলা হলো পবিত্র কাবা শরিফের দিক। মুসলমানরা নামাজের সময় সামর্থ্য অনুযায়ী কিবলামুখী হয়ে নামাজ আদায় করেন।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.history_rounded,
                    'কিবলা পরিবর্তনের ইতিহাস',
                    'ইসলামের প্রথম যুগে রাসুলুল্লাহ ﷺ বায়তুল মুকাদ্দাসের দিকে মুখ করে নামাজ আদায় করতেন। পরে আল্লাহ তাআলার নির্দেশে কিবলা পবিত্র কাবা শরিফের দিকে পরিবর্তন করা হয়।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.menu_book_rounded,
                    'কুরআনে কিবলার নির্দেশ',
                    'সূরা আল-বাকারা ২:১৪২–১৪৪-এ কিবলা পরিবর্তনের বিষয়টি বর্ণিত হয়েছে। বিশেষ করে ২:১৪৪ আয়াতে মসজিদুল হারামের দিকে মুখ করার নির্দেশ রয়েছে.',
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFC9A227).withValues(alpha: .25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'সূরা আল-বাকারা — ২:১৪৪',
                          style: TextStyle(
                            color: const Color(0xFFC9A227),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'قَدْ نَرَىٰ تَقَلُّبَ وَجْهِكَ فِي السَّمَاءِ ۖ فَلَنُوَلِّيَنَّكَ قِبْلَةً تَرْضَاهَا ۚ فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'অর্থ: আমি অবশ্যই আপনাকে এমন কিবলার দিকে ফিরিয়ে দেব, যা আপনি পছন্দ করেন। সুতরাং আপনি আপনার মুখ মসজিদুল হারামের দিকে ফিরিয়ে নিন।',
                          style: TextStyle(
                            color: textColor,
                            height: 1.6,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.explore_rounded,
                    'এই অ্যাপ কীভাবে কিবলা নির্ণয় করে?',
                    'আপনার বর্তমান অবস্থানের অক্ষাংশ ও দ্রাঘিমাংশ থেকে পবিত্র কাবা শরিফের দিকে ভৌগোলিক bearing হিসাব করা হয়। এরপর ফোনের compass সেই দিক অনুসরণ করতে সাহায্য করে।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.navigation_rounded,
                    'কিবলা নির্ণয়ে নির্ভুলতা',
                    'কম্পাস একটি সহায়ক যন্ত্র। চুম্বক, ধাতব বস্তু, গাড়ি, স্পিকার বা অন্যান্য ইলেকট্রনিক যন্ত্রের কাছাকাছি থাকলে দিকের পাঠে বিচ্যুতি হতে পারে।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.sync_problem_rounded,
                    'কম্পাস ক্যালিব্রেশন',
                    'কম্পাস অস্বাভাবিক মনে হলে ফোনটি ধীরে ধীরে ৮ আকৃতিতে কয়েকবার নড়াচড়া করুন এবং চৌম্বকীয় বস্তু থেকে দূরে গিয়ে আবার চেষ্টা করুন।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.travel_explore_rounded,
                    'ভ্রমণের সময়',
                    'বিমান, জাহাজ বা চলন্ত অবস্থায় অবস্থান ও দিক পরিবর্তিত হতে পারে। তাই প্রয়োজন হলে কিছুক্ষণ পরপর অবস্থান ও compass-এর পাঠ পুনরায় যাচাই করুন।',
                  ),

                  _qiblaInfoSection(
                    surface,
                    textColor,
                    muted,
                    Icons.library_books_rounded,
                    'রেফারেন্স',
                    '• কুরআন মাজিদ — সূরা আল-বাকারা ২:১৪২–১৪৪\n'
                    '• সহিহ বুখারি — কিবলা পরিবর্তন সম্পর্কিত বর্ণনা\n'
                    '• কিবলা নির্ণয় — ভৌগোলিক bearing ও compass পদ্ধতি',
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                      label: const Text('বন্ধ করুন'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _qiblaInfoSection(
    Color surface,
    Color textColor,
    Color muted,
    IconData icon,
    String title,
    String body,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF087A3B).withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF087A3B),
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  body,
                  style: TextStyle(
                    color: muted,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _degreeHeader(QiblaData data) {
    return Column(
      children: [
        Text(
          '${data.bearing.round()}°',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          shortDirectionFromDegrees(data.bearing),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A8754),
          ),
        ),
      ],
    );
  }

  Widget _statusCard(BuildContext context, QiblaData data) {
    final facing = controller.isFacingQibla;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: facing
            ? const Color(0xFFC9A227).withValues(alpha: .12)
            : const Color(0xFF0A8754).withValues(alpha: .07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            facing ? Icons.check_circle : Icons.navigation,
            color: facing
                ? const Color(0xFFC9A227)
                : const Color(0xFF0A8754),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              facing
                  ? 'আপনি কিবলার দিকে মুখ করে আছেন'
                  : 'কিবলার দিকে মুখ করুন',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${controller.qiblaDifference.round()}°',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, QiblaData data) {
    final nearestLocation = _nearestBangladeshLocation(data);

    return Column(
      children: [
        _infoRow(
          Icons.location_on_outlined,
          'বর্তমান অবস্থান',
          nearestLocation == null
              ? '${data.latitude.toStringAsFixed(4)}, ${data.longitude.toStringAsFixed(4)}'
              : '${nearestLocation.district}, ${nearestLocation.division} বিভাগ',
        ),
        _infoRow(
          Icons.mosque_outlined,
          'কাবা থেকে দূরত্ব',
          '${data.distanceKm.toStringAsFixed(1)} কিমি',
        ),
        _infoRow(
          Icons.explore_outlined,
          'কিবলার দিক',
          '${data.bearing.round()}° ${directionFromDegrees(data.bearing)}',
        ),
        if (!controller.compassAvailable)
          _warningRow(
            Icons.warning_amber_rounded,
            'ফোনের কম্পাস সেন্সর পাওয়া যাচ্ছে না।',
          ),
        if (controller.calibrationNeeded)
          _warningRow(
            Icons.sync_problem,
            'কম্পাস calibration প্রয়োজন হতে পারে। ফোনটি ৮ আকৃতিতে নাড়ান।',
          ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(
        icon,
        color: const Color(0xFF0A8754),
      ),
      title: Text(title),
      trailing: Text(
        value,
        textAlign: TextAlign.end,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _warningRow(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Icon(icon, color: Colors.orange, size: 21),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationError(BuildContext context) {
    return SizedBox(
      height: 430,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 55,
                color: Color(0xFF0A8754),
              ),
              const SizedBox(height: 12),
              const Text(
                'বর্তমান অবস্থান পাওয়া যাচ্ছে না',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Location/GPS চালু করে আবার চেষ্টা করুন।',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: controller.refreshLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('আবার চেষ্টা করুন'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A8754),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
