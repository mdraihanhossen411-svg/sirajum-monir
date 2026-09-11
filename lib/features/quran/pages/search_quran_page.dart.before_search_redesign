import 'package:flutter/material.dart';
import '../controllers/search_controller.dart';
import 'surah_detail_page.dart';

const green = Color(0xFF0A8754);

class SearchQuranPage extends StatelessWidget {
  final QuranSearchController controller;

  const SearchQuranPage({super.key, required this.controller});

  Widget _stateMessage(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 58, color: green.withValues(alpha: 0.35)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(green),
            ),
          );
        }

        if (controller.error != null) {
          return Center(child: Text('কুরআন সার্চ লোড করা যায়নি।'));
        }

        if (controller.mode == QuranSearchMode.surah) {
          if (controller.surahs.isEmpty) {
            return _stateMessage(
            Icons.search_off_rounded,
            'কোনো সূরা পাওয়া যায়নি',
            'অন্য নাম, আরবি নাম বা সূরা নম্বর দিয়ে চেষ্টা করুন।',
          );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.surahs.length,
            itemBuilder: (_, i) {
              final s = controller.surahs[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0A8754),
                    child: Text('${s.id}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(
                    '${s.banglaName} • ${s.arabicName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${s.englishName} • ${s.totalAyah} আয়াত',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailPage(surah: s),
                    ),
                  ),
                ),
              );
            },
          );
        }

        if (controller.query.trim().isEmpty) {
          return const Center(
            child: Text(
              'আয়াতের বাংলা অর্থ বা আরবি লিখে সার্চ করুন',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        if (controller.results.isEmpty) {
          return _stateMessage(
            Icons.search_off_rounded,
            'কোনো আয়াত পাওয়া যায়নি',
            'অন্য বাংলা অর্থ বা আরবি শব্দ দিয়ে চেষ্টা করুন।',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.results.length,
          itemBuilder: (_, i) {
            final a = controller.results[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'আয়াত ${a.ayahNumber}',
                      style: const TextStyle(
                        color: Color(0xFF0A8754),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 23,
                        height: 1.8,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.banglaText,
                      style: const TextStyle(fontSize: 16, height: 1.7),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
