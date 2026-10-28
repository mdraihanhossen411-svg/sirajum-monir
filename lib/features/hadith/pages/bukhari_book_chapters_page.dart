import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/bukhari_ifa_data.dart';
import '../data/bukhari_bab_data.dart';
import '../models/bukhari_book.dart';
import '../models/bukhari_hadith.dart';

class BukhariBookChaptersPage extends StatefulWidget {
  final BukhariBook book;
  final int? initialHadithNumber;

  const BukhariBookChaptersPage({
    super.key,
    required this.book,
    this.initialHadithNumber,
  });

  @override
  State<BukhariBookChaptersPage> createState() =>
      _BukhariBookChaptersPageState();
}

class _BukhariBookChaptersPageState
    extends State<BukhariBookChaptersPage> {
  static const _green = Color(0xFF087A3B);
  static const _deepGreen = Color(0xFF063B25);
  static const _gold = Color(0xFFC9A227);
  static const _cream = Color(0xFFFFFCF4);
  static const _softGreen = Color(0xFFEAF6F0);

  final Set<int> _bookmarked = {};

  bool _showArabic = true;
  bool _showHarakat = true;
  double _arabicFontSize = 21;
  double _translationFontSize = 16;
  String _arabicFont = 'MeQuran';
  bool _nightMode = false;
  bool _slideView = false;

  final ScrollController _scrollController = ScrollController();
  late final PageController _pageController;
  final Map<int, GlobalKey> _hadithKeys = <int, GlobalKey>{};

  List<BukhariHadith> get _hadiths {
    return BukhariIfaData.hadithsForBook(widget.book.number);
  }

  @override
  void initState() {
    super.initState();
    _loadReaderSettings();

    final hadiths = _hadiths;

    int initialIndex = 0;

    if (widget.initialHadithNumber != null) {
      final index = hadiths.indexWhere(
        (hadith) => hadith.number == widget.initialHadithNumber,
      );

      if (index >= 0) {
        initialIndex = index;
      }
    }

    _pageController = PageController(
      initialPage: initialIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.initialHadithNumber == null) {
        return;
      }

      if (_slideView) {
        return;
      }

      _scrollToTargetHadith();
    });
  }

  Future<void> _loadReaderSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _showArabic = prefs.getBool('bukhari_show_arabic') ?? true;
      _showHarakat = prefs.getBool('bukhari_show_harakat') ?? true;
      _arabicFontSize =
          prefs.getDouble('bukhari_arabic_font_size') ?? 21;
      _translationFontSize =
          prefs.getDouble('bukhari_translation_font_size') ?? 16;
      _arabicFont =
          prefs.getString('bukhari_arabic_font') ?? 'MeQuran';
      _nightMode = prefs.getBool('bukhari_night_mode') ?? false;
      _slideView = prefs.getBool('bukhari_slide_view') ?? false;
    });

    if (_slideView && _pageController.hasClients) {
      _pageController.jumpToPage(
        widget.initialHadithNumber == null
            ? 0
            : _hadiths.indexWhere(
                (h) => h.number == widget.initialHadithNumber,
              ).clamp(0, _hadiths.length - 1),
      );
    }
  }

  Future<void> _saveReaderSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('bukhari_show_arabic', _showArabic);
    await prefs.setBool('bukhari_show_harakat', _showHarakat);
    await prefs.setDouble(
      'bukhari_arabic_font_size',
      _arabicFontSize,
    );
    await prefs.setDouble(
      'bukhari_translation_font_size',
      _translationFontSize,
    );
    await prefs.setString('bukhari_arabic_font', _arabicFont);
    await prefs.setBool('bukhari_night_mode', _nightMode);
    await prefs.setBool('bukhari_slide_view', _slideView);
  }

  void _scrollToTargetHadith() {
    final hadithNumber = widget.initialHadithNumber;

    if (hadithNumber == null) {
      return;
    }

    final key = _hadithKeys[hadithNumber];

    if (key?.currentContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOut,
      alignment: 0.04,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hadiths = _hadiths;

    return Scaffold(
      backgroundColor:
          _nightMode ? const Color(0xFF101512) : const Color(0xFFF5F7F5),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'সহীহ বুখারী',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.book.bengaliName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'রিডার সেটিংস',
            icon: const Icon(Icons.tune_rounded),
            onPressed: _showReaderSettings,
          ),
        ],
      ),
      body: hadiths.isEmpty
          ? _buildEmptyState()
          : _slideView
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];

                    final key = _hadithKeys.putIfAbsent(
                      hadith.number,
                      () => GlobalKey(),
                    );

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(6, 8, 6, 18),
                      child: Container(
                        key: key,
                        child: _buildHadithCard(hadith),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(6, 8, 6, 18),
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];

                    final key = _hadithKeys.putIfAbsent(
                      hadith.number,
                      () => GlobalKey(),
                    );

                    return Container(
                      key: key,
                      child: _buildHadithCard(hadith),
                    );
                  },
                ),
    );
  }

  Widget _buildHadithCard(BukhariHadith hadith) {
    final bab = _babForHadith(hadith);

    return _HadithCard(
      hadith: hadith,
      babTitle: bab?.title,
      babArabic: bab?.arabic,
      green: _green,
      deepGreen: _deepGreen,
      gold: _gold,
      cream: _cream,
      softGreen: _softGreen,
      bookmarked: _bookmarked.contains(hadith.number),
      showArabic: _showArabic,
      showHarakat: _showHarakat,
      arabicFontSize: _arabicFontSize,
      translationFontSize: _translationFontSize,
      arabicFont: _arabicFont,
      nightMode: _nightMode,
      onBookmark: () {
        setState(() {
          if (_bookmarked.contains(hadith.number)) {
            _bookmarked.remove(hadith.number);
          } else {
            _bookmarked.add(hadith.number);
          }
        });
      },
    );
  }

  _BabInfo? _babForHadith(BukhariHadith hadith) {
    for (final bab in BukhariBabData.books) {
      if (bab.bookNumber == widget.book.number &&
          bab.startHadith == hadith.number) {
        return _BabInfo(
          title: bab.title,
          arabic: bab.arabic,
        );
      }
    }

    return null;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Card(
          elevation: 2,
          color: _nightMode ? const Color(0xFF17221C) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 58,
                  color: _green.withValues(alpha: .75),
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.book.number}. ${widget.book.bengaliName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _nightMode ? Colors.white : _deepGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.book.arabicName,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: _nightMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'এই কিতাবের হাদিসের ডাটা এখনো যুক্ত করা হয়নি।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: _nightMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReaderSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor:
          _nightMode ? const Color(0xFF17221C) : Colors.white,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          color: _green,
                          size: 27,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          'সেটিংস',
                          style: TextStyle(
                            color: _nightMode ? Colors.white : _deepGreen,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const _SettingsSectionTitle(
                      title: 'কন্টেন্ট সেটিংস',
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'আরবি দেখান',
                        style: TextStyle(
                          color:
                              _nightMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: _showArabic,
                      onChanged: (value) {
                        modalSetState(() {
                          _showArabic = value;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'যবর-যের',
                        style: TextStyle(
                          color:
                              _nightMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _showHarakat
                            ? 'হারকাতসহ আরবি'
                            : 'হারকাত ছাড়া আরবি',
                        style: TextStyle(
                          color:
                              _nightMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      value: _showHarakat,
                      onChanged: (value) {
                        modalSetState(() {
                          _showHarakat = value;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    const SizedBox(height: 12),
                    const _SettingsSectionTitle(
                      title: 'ফন্ট সেটিংস',
                    ),

                    Text(
                      'আরবি ফন্টের আকার: ${_arabicFontSize.round()}',
                      style: TextStyle(
                        color: _nightMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      min: 16,
                      max: 32,
                      divisions: 16,
                      value: _arabicFontSize,
                      label: _arabicFontSize.round().toString(),
                      onChanged: (value) {
                        modalSetState(() {
                          _arabicFontSize = value;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    Text(
                      'অনুবাদ ফন্টের আকার: ${_translationFontSize.round()}',
                      style: TextStyle(
                        color: _nightMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      min: 12,
                      max: 33,
                      divisions: 21,
                      value: _translationFontSize,
                      label: _translationFontSize.round().toString(),
                      onChanged: (value) {
                        modalSetState(() {
                          _translationFontSize = value;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    const SizedBox(height: 6),
                    Text(
                      'আরবি ফন্ট',
                      style: TextStyle(
                        color: _nightMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'MeQuran',
                          label: Text('Me Quran'),
                        ),
                        ButtonSegment(
                          value: 'KFGQ',
                          label: Text('KFGQ'),
                        ),
                      ],
                      selected: {_arabicFont},
                      onSelectionChanged: (selection) {
                        modalSetState(() {
                          _arabicFont = selection.first;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    const SizedBox(height: 20),
                    const _SettingsSectionTitle(
                      title: 'ভিউ সেটিংস',
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'নাইট মোড',
                        style: TextStyle(
                          color:
                              _nightMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: _nightMode,
                      onChanged: (value) {
                        modalSetState(() {
                          _nightMode = value;
                        });
                        setState(() {});
                        _saveReaderSettings();
                      },
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'ভিউ',
                      style: TextStyle(
                        color: _nightMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _ViewModeButton(
                            icon: Icons.view_agenda_rounded,
                            label: 'লিস্ট ভিউ',
                            selected: !_slideView,
                            onTap: () {
                              modalSetState(() {
                                _slideView = false;
                              });
                              setState(() {});
                              _saveReaderSettings();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ViewModeButton(
                            icon: Icons.view_carousel_rounded,
                            label: 'স্লাইড ভিউ',
                            selected: _slideView,
                            onTap: () {
                              modalSetState(() {
                                _slideView = true;
                              });
                              setState(() {});
                              _saveReaderSettings();
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _green,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text(
                        'সম্পন্ন',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BabInfo {
  final String title;
  final String arabic;

  const _BabInfo({
    required this.title,
    required this.arabic,
  });
}

class _HadithCard extends StatelessWidget {
  final BukhariHadith hadith;
  final String? babTitle;
  final String? babArabic;
  final Color green;
  final Color deepGreen;
  final Color gold;
  final Color cream;
  final Color softGreen;
  final bool bookmarked;
  final bool showArabic;
  final bool showHarakat;
  final double arabicFontSize;
  final double translationFontSize;
  final String arabicFont;
  final bool nightMode;
  final VoidCallback onBookmark;

  const _HadithCard({
    required this.hadith,
    this.babTitle,
    this.babArabic,
    required this.green,
    required this.deepGreen,
    required this.gold,
    required this.cream,
    required this.softGreen,
    required this.bookmarked,
    required this.showArabic,
    required this.showHarakat,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.arabicFont,
    required this.nightMode,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: nightMode ? const Color(0xFF17221C) : Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (babTitle != null) ...[
              _buildBabHeader(),
              const SizedBox(height: 10),
            ],
            _buildHeader(context),
            if (showArabic) ...[
              const SizedBox(height: 8),
              _buildArabic(),
            ],
            const SizedBox(height: 5),
            _buildBangla(),
            const SizedBox(height: 5),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildBabHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: nightMode
            ? const Color(0xFF20352A)
            : softGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gold.withValues(alpha: .60),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'পরিচ্ছেদ',
            style: TextStyle(
              color: nightMode
                  ? Colors.white
                  : deepGreen,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            babTitle!,
            style: TextStyle(
              color: nightMode
                  ? Colors.white
                  : deepGreen,
              fontSize: 17,
              height: 1.30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              babArabic!,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: nightMode
                    ? Colors.white
                    : Colors.black87,
                fontSize: 18,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'বোখারি শরিফ',
                      style: TextStyle(
                        color: nightMode
                            ? Colors.white
                            : const Color(0xFF17231D),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  _SahihButton(
                    green: green,
                    onTap: () => _showSahihHadith(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'হাদিস ${_banglaDigits(hadith.number)}',
                style: TextStyle(
                  color: green,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 30,
          height: 30,
          child: PopupMenuButton<String>(
            tooltip: 'আরও',
            padding: EdgeInsets.zero,
            iconSize: 23,
            icon: Icon(
              Icons.more_vert_rounded,
              color: nightMode ? Colors.white70 : deepGreen,
            ),
            onSelected: (value) => _handleMenu(context, value),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'go',
                child: Text('হাদিসে যান'),
              ),
              PopupMenuItem(
                value: 'bookmark',
                child: Text('বুকমার্ক হাদিস'),
              ),
              PopupMenuItem(
                value: 'copy_all',
                child: Text('সম্পূর্ণ হাদিস কপি করুন'),
              ),
              PopupMenuItem(
                value: 'copy_arabic',
                child: Text('আরবি কপি করুন'),
              ),
              PopupMenuItem(
                value: 'copy_translation',
                child: Text('অনুবাদ কপি করুন'),
              ),
              PopupMenuItem(
                value: 'share',
                child: Text('লিঙ্ক শেয়ার'),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text('রিপোর্ট করুন'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArabic() {
    final arabicText =
        showHarakat ? hadith.arabic : _removeHarakat(hadith.arabic);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
      decoration: BoxDecoration(
        color: nightMode
            ? const Color(0xFF1D2B24)
            : const Color(0xFFF3F9F6),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: green.withValues(alpha: .10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'আরবি',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: green,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arabicText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: arabicFont,
              fontSize: arabicFontSize,
              height: 2.0,
              color: nightMode
                  ? Colors.white
                  : const Color(0xFF17231D),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBangla() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 18,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'বাংলা অনুবাদ',
              style: TextStyle(
                color: green,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          hadith.bengali,
          style: TextStyle(
            fontSize: translationFontSize,
            height: 1.7,
            color: nightMode
                ? Colors.white
                : const Color(0xFF18211D),
          ),
        ),
      ],
    );
  }

  Widget _buildNote() {
    if (hadith.note.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: nightMode
            ? const Color(0xFF2A281C)
            : cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: gold.withValues(alpha: .25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sticky_note_2_outlined,
            size: 17,
            color: gold,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'নোট',
                  style: TextStyle(
                    color: nightMode
                        ? Colors.white
                        : deepGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hadith.note,
                  style: TextStyle(
                    color: nightMode
                        ? Colors.white60
                        : Colors.blueGrey,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSahihHadith(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor:
          nightMode ? const Color(0xFF17221C) : Colors.white,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: green,
                      size: 29,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'সহিহ হাদিস',
                      style: TextStyle(
                        color: green,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'যে হাদীসের সানাদ অবিচ্ছিন্ন হয়, বর্ণনাকারীরা ন্যায়পরায়ণ ও পূর্ণ আয়ত্বশক্তির অধিকারী হন এবং সানাদটি শা\'জ ও মু\'আল্লাল না হয় সে হাদীসকে সহীহ বা সহীহ লিযাতিহী। গ্রহণযোগ্য হাদীসগুলোর মধ্যে সহীহ লিযাতিহী\'র মর্যাদা সবচেয়ে বেশী ।',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color:
                        nightMode ? Colors.white : const Color(0xFF18211D),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenu(BuildContext context, String value) {
    switch (value) {
      case 'go':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'হাদিস ${_banglaDigits(hadith.number)}-এ আছেন।',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'bookmark':
        onBookmark();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bookmarked
                  ? 'বুকমার্ক থেকে হাদিসটি সরানো হয়েছে।'
                  : 'হাদিসটি বুকমার্ক করা হয়েছে।',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'copy_all':
        _copy(
          context,
          '''বোখারি শরিফ
হাদিস ${_banglaDigits(hadith.number)}

আরবি:
${hadith.arabic}

বাংলা অনুবাদ:
${hadith.bengali}

নোট:
${hadith.note}''',
          'সম্পূর্ণ হাদিস কপি করা হয়েছে।',
        );
        break;

      case 'copy_arabic':
        _copy(
          context,
          hadith.arabic,
          'আরবি কপি করা হয়েছে।',
        );
        break;

      case 'copy_translation':
        _copy(
          context,
          hadith.bengali,
          'অনুবাদ কপি করা হয়েছে।',
        );
        break;

      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'লিঙ্ক শেয়ার ফিচার পরবর্তী ধাপে যুক্ত হবে।',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'রিপোর্ট ফিচার পরবর্তী ধাপে যুক্ত হবে।',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  void _copy(
    BuildContext context,
    String text,
    String message,
  ) {
    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _removeHarakat(String text) {
    return text.replaceAll(
      RegExp(
        r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]',
      ),
      '',
    );
  }

  static String _banglaDigits(int number) {
    const english = '0123456789';
    const bangla = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((digit) {
          final index = english.indexOf(digit);
          return index == -1 ? digit : bangla[index];
        })
        .join();
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;

  const _SettingsSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF087A3B),
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Material(
        color: selected
            ? const Color(0xFF087A3B)
            : const Color(0xFFEAF6F0),
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? Colors.white
                    : const Color(0xFF087A3B),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(0xFF087A3B),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SahihButton extends StatelessWidget {
  final Color green;
  final VoidCallback onTap;

  const _SahihButton({
    required this.green,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Material(
        color: green,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Center(
              child: Text(
                'সহিহ হাদিস',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
