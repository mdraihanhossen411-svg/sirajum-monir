import 'package:flutter/material.dart';

import '../../prayer/pages/prayer_page.dart';
import '../../quran/pages/quran_page.dart';
import '../../hadith/pages/hadith_page.dart';
import '../../fatwa/pages/fatwa_page.dart';
import '../../calendar/pages/calendar_home_page.dart';
import '../../ramadan/pages/ramadan_page.dart';
import '../../tasbih/pages/tasbih_page.dart';
import '../../audio_quran/pages/audio_quran_page.dart';
import '../../tafsir/pages/tafsir_page.dart';
import '../../tasawwuf/pages/tasawwuf_page.dart';
import '../../books/pages/books_page.dart';
import '../../audio_live/pages/audio_live_page.dart';
import '../../qibla/pages/qibla_page.dart';
import '../../dua/pages/dua_page.dart';
import '../../hajj_umrah/pages/hajj_umrah_page.dart';
import '../../sadaqah/pages/sadaqah_page.dart';

import '../../../core/widgets/islamic_feature_card.dart';

class HomeAllFeaturesGrid extends StatelessWidget {
  const HomeAllFeaturesGrid({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = <Map<String, dynamic>>[
      {'title': 'কুরআন শরীফ', 'icon': Icons.menu_book, 'page': const QuranPage()},
      {'title': 'Audio কুরআন', 'icon': Icons.headphones, 'page': const AudioQuranPage()},
      {'title': 'তাফসির', 'icon': Icons.auto_stories, 'page': const TafsirPage()},
      {'title': 'হাদিস', 'icon': Icons.library_books, 'page': const HadithPage()},
      {'title': 'ফতওয়া', 'icon': Icons.balance, 'page': const FatwaPage()},
      {'title': 'ইলমে তাছাউফ', 'icon': Icons.self_improvement, 'page': const TasawwufPage()},
      {'title': 'ইসলামী বুক', 'icon': Icons.import_contacts, 'page': const BooksPage()},
      {'title': 'অডিও লাইভ', 'icon': Icons.mic, 'page': const AudioLivePage()},
      {'title': 'দোয়া', 'icon': Icons.volunteer_activism, 'page': const DuaPage()},
      {'title': 'কিবলা', 'icon': Icons.explore, 'page': const QiblaPage()},
      {'title': 'নামাজ ও আমল', 'icon': Icons.mosque, 'page': const PrayerPage()},
      {'title': 'ইসলামিক ক্যালেন্ডার', 'icon': Icons.calendar_month, 'page': const CalendarHomePage()},
      {'title': 'রমজান', 'icon': Icons.nights_stay, 'page': const RamadanPage()},
      {'title': 'তাসবিহ', 'icon': Icons.favorite, 'page': const TasbihPage()},
      {'title': 'হজ ও উমরাহ', 'icon': Icons.mosque_outlined, 'page': const HajjUmrahPage()},
      {'title': 'সাদাকাহ', 'icon': Icons.volunteer_activism_outlined, 'page': const SadaqahPage()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 7,
        mainAxisSpacing: 9,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];

        return IslamicFeatureCard(
          title: feature['title'] as String,
          icon: feature['icon'] as IconData,
          onTap: () {
            final page = feature['page'] as Widget;

_open(context, page);
          },
        );
      },
    );
  }
}
