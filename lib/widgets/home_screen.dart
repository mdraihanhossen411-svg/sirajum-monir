import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Sirajum Monir",
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            buildMenuItem(context, Icons.menu_book, "Quran"),
            buildMenuItem(context, Icons.book, "Hadith"),
            buildMenuItem(context, Icons.favorite, "Dua"),
            buildMenuItem(context, Icons.access_time, "Prayer"),
            buildMenuItem(context, Icons.explore, "Qibla"),
            buildMenuItem(context, Icons.calendar_month, "Hijri Calendar"),
            buildMenuItem(context, Icons.auto_stories, "Books"),
            buildMenuItem(context, Icons.settings, "Settings"),
          ],
        ),
      ),
    );
  }
}
