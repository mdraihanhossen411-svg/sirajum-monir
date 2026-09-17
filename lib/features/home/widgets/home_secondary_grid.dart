import 'package:flutter/material.dart';

import '../../prayer/pages/prayer_page.dart';
import '../../hijri/pages/hijri_page.dart';
import '../../ramadan/pages/ramadan_page.dart';
import '../../tasbih/pages/tasbih_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../learning/pages/learning_page.dart';
import '../../dashboard/pages/dashboard_page.dart';
import '../../library/pages/library_page.dart';
import '../../notifications/pages/notifications_page.dart';
import '../../../core/widgets/islamic_feature_card.dart';

class HomeSecondaryGrid extends StatelessWidget {
  const HomeSecondaryGrid({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = <Map<String, dynamic>>[
      {'title': 'নামাজ ও আমল', 'icon': Icons.mosque, 'page': const PrayerPage()},
      {'title': 'ইসলামিক ক্যালেন্ডার', 'icon': Icons.calendar_month, 'page': const HijriPage()},
      {'title': 'রমজান', 'icon': Icons.nights_stay, 'page': const RamadanPage()},
      {'title': 'তাসবিহ', 'icon': Icons.favorite, 'page': const TasbihPage()},
      {'title': 'নোটিফিকেশন', 'icon': Icons.notifications, 'page': const NotificationsPage()},
      {'title': 'ইসলামী শিক্ষা', 'icon': Icons.school, 'page': const LearningPage()},
      {'title': 'ড্যাশবোর্ড', 'icon': Icons.dashboard, 'page': const DashboardPage()},
      {'title': 'আমার লাইব্রেরি', 'icon': Icons.bookmark, 'page': const LibraryPage()},
      {'title': 'সেটিংস', 'icon': Icons.settings, 'page': const SettingsPage()},
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
          onTap: () => _open(
            context,
            feature['page'] as Widget,
          ),
        );
      },
    );
  }
}
