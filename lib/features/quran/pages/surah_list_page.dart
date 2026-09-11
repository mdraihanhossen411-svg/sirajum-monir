import 'package:flutter/material.dart';

import '../controllers/quran_controller.dart';
import '../models/quran_model.dart';
import '../widgets/surah_card.dart';
import 'surah_detail_page.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  final QuranController _controller = QuranController();

  @override
  void initState() {
    super.initState();
    _controller.loadSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_controller.surahList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 58,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.35),
                ),
                const SizedBox(height: 12),
                const Text(
                  'কোনো সূরা পাওয়া যায়নি',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: 6,
            bottom: 16,
          ),
          itemCount: _controller.surahList.length,
          itemBuilder: (context, index) {
            final SurahModel surah = _controller.surahList[index];

            return SurahCard(
              surah: surah,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahDetailPage(
                      surah: surah,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
