import 'package:flutter/material.dart';

class QuranDetailsScreen extends StatelessWidget {
  final String surahName;
  final String arabicName;

  const QuranDetailsScreen({
    super.key,
    required this.surahName,
    required this.arabicName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.green.shade50,

            child: Column(
              children: [

                Text(
                  arabicName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  surahName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Play Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [

                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "الرَّحْمٰنِ الرَّحِيْمِ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "বাংলা অনুবাদ এখানে দেখানো হবে।",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
