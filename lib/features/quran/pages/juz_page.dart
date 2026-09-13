import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'para_detail_page.dart';

class JuzPage extends StatefulWidget {
  const JuzPage({super.key});

  @override
  State<JuzPage> createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  late Future<_JuzData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_JuzData> _loadData() async {
    final juzRaw = await rootBundle.loadString(
      'assets/json/quran/juz.json',
    );

    final surahRaw = await rootBundle.loadString(
      'assets/json/quran/surah_list.json',
    );

    final juzList = (jsonDecode(juzRaw) as List)
        .map(
          (e) => Map<String, dynamic>.from(
            e as Map,
          ),
        )
        .toList();

    final surahList = (jsonDecode(surahRaw) as List)
        .map(
          (e) => Map<String, dynamic>.from(
            e as Map,
          ),
        )
        .toList();

    return _JuzData(
      juzList: juzList,
      surahList: surahList,
    );
  }

  Map<String, dynamic>? _findSurah(
    List<Map<String, dynamic>> surahs,
    int id,
  ) {
    for (final surah in surahs) {
      if (_toInt(surah['id']) == id) {
        return surah;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _getSurahRanges(
    Map<String, dynamic> para,
    List<Map<String, dynamic>> surahs,
  ) {
    final startSurah = _toInt(para['startSurah']);
    final startAyah = _toInt(para['startAyah']);
    final endSurah = _toInt(para['endSurah']);
    final endAyah = _toInt(para['endAyah']);

    final result = <Map<String, dynamic>>[];

    for (int id = startSurah; id <= endSurah; id++) {
      final surah = _findSurah(surahs, id);

      if (surah == null) continue;

      final totalAyah = _toInt(surah['totalAyah']);

      final from = id == startSurah ? startAyah : 1;
      final to = id == endSurah ? endAyah : totalAyah;

      result.add({
        'surah': surah,
        'from': from,
        'to': to,
      });
    }

    return result;
  }

  String _banglaNumber(int number) {
    const english = '0123456789';
    const bangla = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map(
          (char) => bangla[english.indexOf(char)],
        )
        .join();
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0A8754);
    const gold = Color(0xFFC9A227);

    return FutureBuilder<_JuzData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'পারা লোড করা যায়নি\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final data = snapshot.data;

        if (data == null || data.juzList.isEmpty) {
          return const Center(
            child: Text('কোনো পারা পাওয়া যায়নি'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            12,
            10,
            12,
            24,
          ),
          itemCount: data.juzList.length,
          itemBuilder: (context, index) {
            final para = data.juzList[index];

            final number = _toInt(para['number']);
            final name = para['name']?.toString() ?? '';

            final ranges = _getSurahRanges(
              para,
              data.surahList,
            );

            // ১ম পারার বর্ণনায় display-এর জন্য সূরা ফাতিহা যোগ।
            // আসল juz.json-এর সীমা অপরিবর্তিত থাকবে।
            if (number == 1 && ranges.isNotEmpty) {
              final fatiha = _findSurah(data.surahList, 1);
              if (fatiha != null) {
                ranges.insert(0, {
                  'surah': fatiha,
                  'from': 1,
                  'to': _toInt(fatiha['totalAyah']),
                });
              }
            }

            return _JuzCard(
              number: number,
              banglaNumber: _banglaNumber(number),
              name: name,
              ranges: ranges,
              green: green,
              gold: gold,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParaDetailPage(
                      para: para,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _JuzData {
  final List<Map<String, dynamic>> juzList;
  final List<Map<String, dynamic>> surahList;

  const _JuzData({
    required this.juzList,
    required this.surahList,
  });
}

class _JuzCard extends StatelessWidget {
  final int number;
  final String banglaNumber;
  final String name;
  final List<Map<String, dynamic>> ranges;
  final Color green;
  final Color gold;
  final VoidCallback onTap;

  const _JuzCard({
    required this.number,
    required this.banglaNumber,
    required this.name,
    required this.ranges,
    required this.green,
    required this.gold,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surface = isDark
        ? const Color(0xFF17271E)
        : Colors.white;

    final textColor = isDark
        ? Colors.white
        : const Color(0xFF18352A);

    final secondaryColor = isDark
        ? Colors.white70
        : Colors.black54;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      color: surface,
      shadowColor: green.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: gold.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            16,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: gold,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        banglaNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'পারা $banglaNumber',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'الجزء $number',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: green,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.menu_book_rounded,
                    color: gold,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (ranges.isNotEmpty) ...[
                      const SizedBox(height: 12),

                      Divider(
                        height: 1,
                        color: gold.withValues(
                          alpha: 0.25,
                        ),
                      ),

                      const SizedBox(height: 8),

                      ...ranges.map(
                        (item) {
                          final surah =
                              item['surah']
                                  as Map<String, dynamic>;

                          final banglaName =
                              surah['banglaName']
                                  ?.toString() ??
                              '';

                          final arabicName =
                              surah['arabicName']
                                  ?.toString() ??
                              '';

                          final from =
                              item['from'] as int;

                          final to =
                              item['to'] as int;

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment:
                                      Alignment.center,
                                  decoration:
                                      BoxDecoration(
                                    color: gold.withValues(
                                      alpha: 0.13,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    surah['id']
                                        .toString(),
                                    style: TextStyle(
                                      color: green,
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 9),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        'সূরা $banglaName',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 2,
                                      ),

                                      Text(
                                        '$arabicName  •  আয়াত $from–$to',
                                        textDirection:
                                            TextDirection
                                                .rtl,
                                        style: TextStyle(
                                          color:
                                              secondaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.chevron_right,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
