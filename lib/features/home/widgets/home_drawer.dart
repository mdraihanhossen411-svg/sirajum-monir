import 'package:flutter/material.dart';

import '../../about/pages/about_page.dart';
import '../../dua/pages/dua_page.dart';
import '../../hadith/pages/hadith_page.dart';
import '../../prayer/pages/prayer_page.dart';
import '../../qibla/pages/qibla_page.dart';
import '../../quran/pages/quran_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../tasbih/pages/tasbih_page.dart';

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
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0A8754),
            ),
            accountName: Text(
              "Sirajum Monir",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "The Complete Islamic Companion",
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu_book,
                color: Color(0xFF0A8754),
                size: 40,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("হোম"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("আল-কুরআন"),
            onTap: () {
              _openPage(context, const QuranPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text("হাদিস"),
            onTap: () {
              _openPage(context, const HadithPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.pan_tool),
            title: const Text("দোয়া"),
            onTap: () {
              _openPage(context, const DuaPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("তাসবিহ"),
            onTap: () {
              _openPage(context, const TasbihPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.mosque),
            title: const Text("নামাজ"),
            onTap: () {
              _openPage(context, const PrayerPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text("কিবলা"),
            onTap: () {
              _openPage(context, const QiblaPage());
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("সেটিংস"),
            onTap: () {
              _openPage(context, const SettingsPage());
            },
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              _openPage(context, const AboutPage());
            },
          ),
        ],
      ),
    );
  }
}