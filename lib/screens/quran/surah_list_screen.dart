import 'package:flutter/material.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  final List<Map<String, String>> surahs = const [
    {
      "id": "1",
      "name": "Al-Fatihah",
      "arabic": "الفاتحة",
      "ayah": "7 Ayahs"
    },
    {
      "id": "2",
      "name": "Al-Baqarah",
      "arabic": "البقرة",
      "ayah": "286 Ayahs"
    },
    {
      "id": "3",
      "name": "Ali-Imran",
      "arabic": "آل عمران",
      "ayah": "200 Ayahs"
    },
    {
      "id": "4",
      "name": "An-Nisa",
      "arabic": "النساء",
      "ayah": "176 Ayahs"
    },
    {
      "id": "5",
      "name": "Al-Ma'idah",
      "arabic": "المائدة",
      "ayah": "120 Ayahs"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surah List"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  surah["id"]!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                surah["name"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(surah["ayah"]!),
              trailing: Text(
                surah["arabic"]!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // পরে Surah Details Screen-এ যাবে
              },
            ),
          );
        },
      ),
    );
  }
}
