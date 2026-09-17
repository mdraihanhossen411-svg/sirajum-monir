import 'package:flutter/material.dart';

import '../../about/pages/about_page.dart';
import '../../account/pages/account_page.dart';
import '../../dashboard/pages/dashboard_page.dart';
import '../../family/pages/family_page.dart';
import '../../learning/pages/learning_page.dart';
import '../../library/pages/library_page.dart';
import '../../mosque/pages/mosque_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../smart/pages/smart_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0A8754),
            ),
            accountName: const Text(
              'Sirajum Monir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(
              'The Complete Islamic Companion',
            ),
            currentAccountPicture: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountPage(),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  color: Color(0xFF0A8754),
                  size: 48,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('হোম'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('আমার লাইব্রেরী'),
            onTap: () {
              _openPage(context, const LibraryPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('ইসলামিক শিক্ষা'),
            onTap: () {
              _openPage(context, const LearningPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('স্মার্ট ইসলামিক'),
            onTap: () {
              _openPage(context, const SmartPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('ড্যাশবোর্ড'),
            onTap: () {
              _openPage(context, const DashboardPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.mosque),
            title: const Text('মসজিদ'),
            onTap: () {
              _openPage(context, const MosquePage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('পরিবার'),
            onTap: () {
              _openPage(context, const FamilyPage());
            },
          ),


          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('সেটিংস'),
            onTap: () {
              _openPage(context, const SettingsPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              _openPage(context, const AboutPage());
            },
          ),
        ],
      ),
    );
  }
}
