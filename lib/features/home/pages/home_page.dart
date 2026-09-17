import 'package:flutter/material.dart';

import '../../../core/widgets/islamic_section_header.dart';
import '../../search/pages/search_page.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_all_features_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'অনুসন্ধান',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 9),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _openPage(
                  context,
                  const SearchPage(),
                ),
                child: IgnorePointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'কুরআন, হাদিস, দোয়া খুঁজুন...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const IslamicSectionHeader(
                title: 'সকল ইসলামিক ফিচার',
                icon: Icons.auto_awesome,
              ),
              const SizedBox(height: 10),
              const HomeAllFeaturesGrid(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
