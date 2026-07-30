import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../screens/quran/surah_details_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  List<dynamic> surahs = [];

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    final String data =
        await rootBundle.loadString('assets/json/surahs.json');

    setState(() {
      surahs = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al Quran"),
        backgroundColor: Colors.green,
      ),
      body: surahs.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(surah["id"].toString()),
                  ),
                  title: Text(surah["name"]),
                  subtitle: Text(surah["arabic"]),
                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailsScreen(
                          id: surah["id"].toString(),
                          name: surah["name"],
                          arabic: surah["arabic"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
