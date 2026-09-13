import 'package:flutter/material.dart';

import '../models/quran_model.dart';
import '../services/quran_service.dart';
import 'bookmark_page.dart';
import 'juz_page.dart';
import 'surah_detail_page.dart';
import 'surah_list_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
final TextEditingController _surahSearchController =
      TextEditingController();
  final TextEditingController _ayahSearchController =
      TextEditingController();

  SurahModel? _selectedSurah;
  List<SurahModel> _allSurahs = [];

  @override
  void initState() {
    super.initState();
    _loadSearchSurahs();
  }

  Future<void> _loadSearchSurahs() async {
    try {
      final metadata = await QuranService().loadSurahList();

      final surahs = metadata
          .cast<Map>()
          .map(
            (item) => SurahModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _allSurahs = surahs;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _surahSearchController.dispose();
    _ayahSearchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _toEnglishDigits(String value) {
    const bangla = '০১২৩৪৫৬৭৮৯';
    const english = '0123456789';

    var result = value;

    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(bangla[i], english[i]);
    }

    return result;
  }

  Future<void> _findAyah() async {
    final surah = _selectedSurah;

    if (surah == null) {
      _showMessage('আগে একটি সূরা নির্বাচন করুন।');
      return;
    }

    final text = _toEnglishDigits(
      _ayahSearchController.text.trim(),
    );

    final ayah = int.tryParse(text);

    if (ayah == null) {
      _showMessage('সঠিক আয়াত নাম্বার লিখুন।');
      return;
    }

    if (ayah < 1 || ayah > surah.totalAyah) {
      _showMessage(
        'এই সূরায় $ayah নম্বর আয়াত নেই।',
      );
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahDetailPage(
          surah: surah,
          initialAyah: ayah,
        ),
      ),
    );
  }

  Widget _searchSection() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Autocomplete<SurahModel>(
              displayStringForOption: (surah) =>
                  surah.banglaName,
              optionsBuilder: (value) {
                final query = value.text.trim().toLowerCase();

                if (query.isEmpty) {
                  return _allSurahs;
                }

                return _allSurahs.where((surah) {
                  return surah.banglaName
                      .toLowerCase()
                      .contains(query);
                });
              },
              onSelected: (surah) {
                setState(() {
                  _selectedSurah = surah;
                  _surahSearchController.text =
                      surah.banglaName;
                });
              },
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                _surahSearchController.value =
                    controller.value;

                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'সূরা নাম নির্বাচন',
                    prefixIcon: const Icon(
                      Icons.menu_book_rounded,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: surface,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary,
                        width: 1.3,
                      ),
                    ),
                  ),
                );
              },
              optionsViewBuilder:
                  (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 5,
                    borderRadius:
                        BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 320,
                        minWidth: 250,
                      ),
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final surah =
                              options.elementAt(index);

                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 17,
                              backgroundColor: primary,
                              child: Text(
                                '${surah.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              surah.banglaName,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${surah.arabicName} • '
                              '${surah.englishName}',
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                            onTap: () =>
                                onSelected(surah),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            flex: 3,
            child: TextField(
              controller: _ayahSearchController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _findAyah(),
              decoration: InputDecoration(
                hintText: 'আয়াত নাম্বার লিখুন',
                filled: true,
                fillColor: surface,
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primary.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primary.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primary,
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _findAyah,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC9A227),
                  foregroundColor: Colors.white,
                  elevation: 1,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'খুঁজুন',
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'আল-কুরআন',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Column(
                  children: [
                    if (controller.index == 0) ...[
                      const SizedBox(height: 8),
                      _searchSection(),
                      const SizedBox(height: 4),
                    ],
                    const Expanded(
                      child: TabBarView(
                        children: [
                          SurahListPage(),
                          JuzPage(),
                          BookmarkPage(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
