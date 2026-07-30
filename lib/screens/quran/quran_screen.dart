import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  Widget menuCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.green,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al Quran"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [

            menuCard(
              context,
              Icons.menu_book,
              "Surah List",
              "114 Surahs",
            ),

            menuCard(
              context,
              Icons.book,
              "Para List",
              "30 Paras",
            ),

            menuCard(
              context,
              Icons.play_circle_fill,
              "Quran Audio",
              "Listen Quran",
            ),

            menuCard(
              context,
              Icons.bookmark,
              "Bookmarks",
              "Saved Ayahs",
            ),

            menuCard(
              context,
              Icons.search,
              "Search",
              "Search Quran",
            ),

          ],
        ),
      ),
    );
  }
}
