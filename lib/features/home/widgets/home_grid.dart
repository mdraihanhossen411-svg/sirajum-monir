import 'package:flutter/material.dart';

import '../../dua/pages/dua_page.dart';
import '../../hadith/pages/hadith_page.dart';
import '../../hijri/pages/hijri_page.dart';
import '../../prayer/pages/prayer_page.dart';
import '../../qibla/pages/qibla_page.dart';
import '../../quran/pages/quran_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../tasbih/pages/tasbih_page.dart';

import 'feature_card.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        "title": "কুরআন",
        "icon": Icons.menu_book,
        "page": const QuranPage(),
      },
      {
        "title": "হাদিস",
        "icon": Icons.library_books,
        "page": const HadithPage(),
      },
      {
        "title": "দোয়া",
        "icon": Icons.pan_tool,
        "page": const DuaPage(),
      },
      {
        "title": "তাসবিহ",
        "icon": Icons.favorite,
        "page": const TasbihPage(),
      },
      {
        "title": "নামাজ",
        "icon": Icons.mosque,
        "page": const PrayerPage(),
      },
      {
        "title": "কিবলা",
        "icon": Icons.explore,
        "page": const QiblaPage(),
      },
      {
        "title": "হিজরি",
        "icon": Icons.calendar_month,
        "page": const HijriPage(),
      },
      {
        "title": "সেটিংস",
        "icon": Icons.settings,
        "page": const SettingsPage(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];

        return FeatureCard(
          title: feature["title"] as String,
          icon: feature["icon"] as IconData,
          onTap: () {
            _openPage(
              context,
              feature["page"] as Widget,
            );
          },
        );
      },
    );
  }
}