import 'package:flutter/material.dart';

import '../../audio_live/pages/audio_live_page.dart';
import '../../audio_quran/pages/audio_quran_page.dart';
import '../../books/pages/books_page.dart';
import '../../dua/pages/dua_page.dart';
import '../../hadith/pages/hadith_page.dart';
import '../../qibla/pages/qibla_page.dart';
import '../../quran/pages/quran_page.dart';
import '../../tafsir/pages/tafsir_page.dart';
import '../../tasawwuf/pages/tasawwuf_page.dart';
import '../../../core/widgets/islamic_feature_card.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = <Map<String, dynamic>>[
      {
        'title': 'কুরআন শরীফ',
        'icon': Icons.menu_book,
        'page': const QuranPage(),
      },
      {
        'title': 'Audio কুরআন',
        'icon': Icons.headphones,
        'page': const AudioQuranPage(),
      },
      {
        'title': 'তাফসির',
        'icon': Icons.auto_stories,
        'page': const TafsirPage(),
      },
      {
        'title': 'হাদিস',
        'icon': Icons.library_books,
        'page': const HadithPage(),
      },
      {
        'title': 'ইলমে তাছাউফ',
        'icon': Icons.self_improvement,
        'page': const TasawwufPage(),
      },
      {
        'title': 'ইসলামী বুক',
        'icon': Icons.import_contacts,
        'page': const BooksPage(),
      },
      {
        'title': 'অডিও লাইভ',
        'icon': Icons.mic,
        'page': const AudioLivePage(),
      },
      {
        'title': 'দোয়া',
        'icon': Icons.volunteer_activism,
        'page': const DuaPage(),
      },
      {
        'title': 'কিবলা',
        'icon': Icons.explore,
        'page': const QiblaPage(),
      },
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
            _openPage(
              context,
              feature['page'] as Widget,
            );
          },
        );
      },
    );
  }
}
