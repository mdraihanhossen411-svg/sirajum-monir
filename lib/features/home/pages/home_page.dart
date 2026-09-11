import 'package:flutter/material.dart';

import '../../hijri/pages/hijri_page.dart';
import '../../prayer/pages/prayer_page.dart';
import '../../qibla/pages/qibla_page.dart';
import '../../quran/pages/quran_page.dart';
import '../../search/pages/search_page.dart';

import '../widgets/continue_reading_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_grid.dart';

import '../../prayer/widgets/prayer_time_card.dart';
import '../../hijri/widgets/hijri_card.dart';
import '../../qibla/widgets/qibla_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Welcome
            const Text(
              "السلام عليكم ورحمة الله وبركاته",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Sirajum Monir এ স্বাগতম",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            // Search
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchPage(),
                  ),
                );
              },
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: "কুরআন, হাদিস, দোয়া খুঁজুন...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Continue Reading
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuranPage(),
                  ),
                );
              },
              child: const ContinueReadingCard(),
            ),

            const SizedBox(height: 12),

            // Prayer Time
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrayerPage(),
                  ),
                );
              },
              child: PrayerTimeCard(),
            ),

            const SizedBox(height: 12),

            // Hijri
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HijriPage(),
                  ),
                );
              },
              child: const HijriCard(),
            ),

            const SizedBox(height: 12),

            // Qibla
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QiblaPage(),
                  ),
                );
              },
              child: const QiblaCard(),
            ),

            const SizedBox(height: 20),

            // All Features
            const Text(
              "সকল ফিচার",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Feature Grid
            const HomeGrid(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}