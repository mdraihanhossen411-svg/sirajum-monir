import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget menuCard(IconData icon, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Search Quran, Hadith, Dua...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.access_time,
                  color: Colors.green,
                ),
                title: Text("Next Prayer"),
                subtitle: Text("Fajr • 05:02 AM"),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,

                children: [

                  menuCard(Icons.menu_book, "Quran"),

                  menuCard(Icons.book, "Hadith"),

                  menuCard(Icons.favorite, "Dua"),

                  menuCard(Icons.access_time, "Prayer"),

                  menuCard(Icons.explore, "Qibla"),

                  menuCard(Icons.calendar_month, "Hijri Calendar"),

                  menuCard(Icons.auto_stories, "Books"),

                  menuCard(Icons.settings, "Settings"),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
