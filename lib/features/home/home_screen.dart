import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sirajum Monir"),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Center(
                child: Text(
                  "Sirajum Monir",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {
        final state = controller.state.value;

        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [

            _menuCard(
              Icons.menu_book,
              "Quran",
            ),

            _menuCard(
              Icons.book,
              "Hadith",
            ),

            _menuCard(
              Icons.favorite,
              "Dua",
            ),

            _menuCard(
              Icons.access_time,
              "Prayer",
            ),

            _menuCard(
              Icons.explore,
              "Qibla",
            ),

            _menuCard(
              Icons.calendar_month,
              "Hijri",
            ),

            _menuCard(
              Icons.auto_stories,
              "Books",
            ),

            _menuCard(
              Icons.calculate,
              "Tasbih",
            ),
          ],
        );
      }),
    );
  }

  Widget _menuCard(
    IconData icon,
    String title,
  ) {
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
              size: 45,
              color: Colors.green,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
