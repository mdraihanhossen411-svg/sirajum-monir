import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'surah_distribution_page.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/quran_model.dart';
import '../services/bookmark_service.dart';
import '../services/last_read_service.dart';
import '../widgets/ayah_card.dart';

class SurahDetailPage extends StatefulWidget {
  final SurahModel surah;
  final int? initialAyah;

  const SurahDetailPage({
    super.key,
    required this.surah,
    this.initialAyah,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final BookmarkService _bookmarkService = BookmarkService();
  final LastReadService _lastReadService = LastReadService();

  List<Map<String, dynamic>> _ayahs = [];
  final Set<String> _bookmarked = <String>{};
  final ItemScrollController _itemScrollController =
      ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  Timer? _lastReadTimer;

  bool _loading = true;
  String? _error;
  int? _highlightAyah;

  double _arabicFontSize = 29;
  final double _banglaFontSize = 17;

  String _safeString(dynamic value) {
    if (value == null) return '';

    if (value is String) return value;

    if (value is List) {
      return value.map((item) => item?.toString() ?? '').join(' ');
    }

    return value.toString();
  }

  int _safeInt(dynamic value, [int fallback = 0]) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  Map<String, dynamic> _safeMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  String _key(int ayahNumber) {
    return '${widget.surah.id}:$ayahNumber';
  }

  @override
  void initState() {
    super.initState();
    _highlightAyah = widget.initialAyah;
    _itemPositionsListener.itemPositions.addListener(
      _handleVisibleAyahChanged,
    );
    _load();
  }

  void _handleVisibleAyahChanged() {
    if (_ayahs.isEmpty) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    ItemPosition? bestPosition;

    for (final position in positions) {
      final isVisible = position.itemLeadingEdge < 1.0 &&
          position.itemTrailingEdge > 0.0;

      if (!isVisible) continue;

      if (bestPosition == null ||
          position.itemLeadingEdge < bestPosition.itemLeadingEdge) {
        bestPosition = position;
      }
    }

    if (bestPosition == null) return;

    final index = bestPosition.index;
    if (index < 0 || index >= _ayahs.length) return;

    final ayahNumber = _safeInt(_ayahs[index]['number']);
    if (ayahNumber <= 0) return;

    _lastReadTimer?.cancel();

    _lastReadTimer = Timer(
      const Duration(milliseconds: 450),
      () => _saveLastRead(ayahNumber),
    );
  }

  Future<void> _saveLastRead(int ayahNumber) async {
    if (ayahNumber <= 0) return;

    await _lastReadService.save(
      surahId: widget.surah.id,
      surahBangla: _safeString(widget.surah.banglaName),
      surahArabic: _safeString(widget.surah.arabicName),
      surahEnglish: _safeString(widget.surah.englishName),
      ayahNumber: ayahNumber,
      totalAyah: widget.surah.totalAyah,
    );
  }

  Future<void> _load() async {
    try {
      final path =
          'assets/json/quran/core/surah_${widget.surah.id}.json';

      final jsonString = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonString);

      if (decoded is! Map) {
        throw Exception('সূরার JSON ফরম্যাট সঠিক নয়');
      }

      final data = Map<String, dynamic>.from(decoded);

      final rawAyahs = data['ayahs'];

      final List<Map<String, dynamic>> loadedAyahs = [];

      if (rawAyahs is List) {
        for (final item in rawAyahs) {
          final ayah = _safeMap(item);

          if (ayah.isEmpty) continue;

          loadedAyahs.add({
            'number': _safeInt(ayah['number']),
            'arabicText': _safeString(ayah['arabicText']),
            'banglaText': _safeString(ayah['banglaText']),
            'englishText': _safeString(ayah['englishText']),
          });
        }
      }

      final bookmarks = await _bookmarkService.load();

      final Set<String> loadedBookmarks = <String>{};

      for (final bookmark in bookmarks) {
        final bookmarkSurahId = _safeInt(bookmark['surahId']);
        final bookmarkAyahNumber = _safeInt(bookmark['ayahNumber']);

        if (bookmarkSurahId == widget.surah.id &&
            bookmarkAyahNumber > 0) {
          loadedBookmarks.add(_key(bookmarkAyahNumber));
        }
      }

      if (!mounted) return;

      setState(() {
        _ayahs = loadedAyahs;

        _bookmarked
          ..clear()
          ..addAll(loadedBookmarks);

        _loading = false;
        _error = null;
      });

      if (widget.initialAyah != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToAyah(widget.initialAyah!);
        });
      }
    } catch (e, stack) {
      debugPrint('QURAN_DETAIL_ERROR: $e');
      debugPrintStack(stackTrace: stack);

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _scrollToAyah(
  int ayahNumber, [
  int attempt = 0,
]) {
  if (!mounted) return;

  final index = _ayahs.indexWhere(
    (ayah) => _safeInt(ayah['number']) == ayahNumber,
  );

  if (index < 0) return;

  if (!_itemScrollController.isAttached) {
    if (attempt < 30) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToAyah(ayahNumber, attempt + 1);
        }
      });
    }
    return;
  }

  _itemScrollController.scrollTo(
    index: index,
    duration: const Duration(milliseconds: 700),
    curve: Curves.easeOutCubic,
    alignment: 0.12,
  );

  setState(() {
    _highlightAyah = ayahNumber;
  });

  Future.delayed(const Duration(seconds: 3), () {
    if (!mounted) return;

    if (_highlightAyah == ayahNumber) {
      setState(() {
        _highlightAyah = null;
      });
    }
  });
}

  Map<String, dynamic> _bookmarkData(
  Map<String, dynamic> ayah,
) {
  final number = _safeInt(ayah['number']);

  return {
    'surahId': widget.surah.id,
    'surahBangla': _safeString(widget.surah.banglaName),
    'surahArabic': _safeString(widget.surah.arabicName),
    'surahEnglish': _safeString(widget.surah.englishName),
    'totalAyah': widget.surah.totalAyah,
    'ayahNumber': number,
    'arabicText': _safeString(ayah['arabicText']),
    'banglaText': _safeString(ayah['banglaText']),
  };
}

Future<void> _toggleBookmark(
    Map<String, dynamic> ayah,
  ) async {
    final number = _safeInt(ayah['number']);

    if (number <= 0) return;

    final saved = await _bookmarkService.toggle(
      _bookmarkData(ayah),
    );

    if (!mounted) return;

    setState(() {
      if (saved) {
        _bookmarked.add(_key(number));
      } else {
        _bookmarked.remove(_key(number));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'বুকমার্ক সংরক্ষণ করা হয়েছে'
              : 'বুকমার্ক সরানো হয়েছে',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _copyAyah(
    Map<String, dynamic> ayah,
  ) async {
    final number = _safeInt(ayah['number']);

    final arabic = _safeString(ayah['arabicText']);
    final bangla = _safeString(ayah['banglaText']);

    final text = [
      'সূরা ${_safeString(widget.surah.banglaName)} • আয়াত $number',
      '',
      arabic,
      '',
      bangla,
      '',
      '— সিরাজুম মুনির',
    ].join('\n');

    await Clipboard.setData(
      ClipboardData(text: text),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('আয়াত কপি করা হয়েছে'),
        duration: Duration(seconds: 1),
      ),
    );
  }



  Widget _buildAyah(
    int index,
  ) {
    final ayah = _ayahs[index];

    final number = _safeInt(ayah['number']);
    final arabic = _safeString(ayah['arabicText']);
    final bangla = _safeString(ayah['banglaText']);

    final highlighted = _highlightAyah == number;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 1, 8, 2),
        decoration: highlighted
            ? BoxDecoration(
                color: const Color(0xFF0A8754)
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC9A227)
                      .withValues(alpha: 0.55),
                ),
              )
            : null,
        child: AyahCard(
          ayahNumber: number,
          arabicText: arabic,
          banglaText: bangla,
          arabicFontSize: _arabicFontSize,
          banglaFontSize: _banglaFontSize,
          isBookmarked: _bookmarked.contains(_key(number)),
          onBookmark: () => _toggleBookmark(ayah),
          onCopy: () => _copyAyah(ayah),
          onShare: null,
            onTafsir: () => _showTafsirComingSoon(number),
        ),
      ),
    );
  }

  void _showTafsirComingSoon(int ayahNumber) {
    const fatihaTafsir = <int, String>{
      1: 'যেকোনো ভালো কাজ বা ইবাদত আল্লাহর নাম নিয়ে শুরু করার নির্দেশ দেওয়া হয়েছে এখানে। ‘আল্লাহ’ হলো তাঁর সর্বশ্রেষ্ঠ এবং নিজস্ব নাম। ‘আর-রাহমান’ (পরম করুণাময়) অর্থ হলো যাঁর দয়া সমগ্র সৃষ্টিজগতের জন্য উন্মুক্ত। আর ‘আর-রহিম’ (অসীম দয়ালু) অর্থ হলো যাঁর বিশেষ রহমত বা দয়া কেবল মুমিন বা বিশ্বাসীদের জন্য নির্দিষ্ট।',
      2: 'সমস্ত কৃতজ্ঞতা ও প্রশংসা একমাত্র আল্লাহরই প্রাপ্য। কারণ তিনিই ‘রাব্বুল আলামিন’ বা তামাম জাহানের লালনপালনকারী, সৃষ্টিকর্তা ও পরিচালক। তিনি পুরো সৃষ্টিজগৎকে ধাপে ধাপে পূর্ণতার দিকে এগিয়ে নিয়ে যাচ্ছেন।',
      3: 'দ্বিতীয় আয়াতে আল্লাহর প্রভুত্ব ও ক্ষমতার কথা বলার পর, তাঁর রহমত ও দয়ার গুণের পুনরাবৃত্তি করা হয়েছে। এর মাধ্যমে বান্দার মনে ভয়ের পাশাপাশি আল্লাহর প্রতি অগাধ ভালোবাসা ও আশার সঞ্চার ঘটে যে, তাদের পালনকর্তা অত্যন্ত দয়ালু।',
      4: '‘দিন আদ-দ্বীন’ অর্থ প্রতিদান বা বিচারের দিন (আখিরাত)। সেদিন সব মানুষ তাদের ভালো ও মন্দ কাজের পূর্ণ বিচার ও প্রতিদান পাবে। দুনিয়াতে ক্ষমতাশালীরা নিজেদের মালিক দাবি করলেও সেদিন একমাত্র আল্লাহই হবেন সর্বময় ক্ষমতার একক মালিক ও শাসক। এই বিশ্বাস মানুষকে পাপ কাজ থেকে দূরে রাখে।',
      5: 'এটি বান্দা ও আল্লাহর মধ্যকার সম্পর্কের মূল ভিত্তি। এখানে বান্দা ঘোষণা করছে যে, সে ইবাদত, বন্দেগী, উপাসনা ও আনুগত্য একমাত্র আল্লাহর জন্যই করবে এবং বিপদে-আপদে, সব কাজে শক্তি ও সাহায্য পাওয়ার জন্য কেবল তাঁরই ওপর ভরসা করবে।',
      6: 'বান্দা এখন আল্লাহর কাছে সবচেয়ে বড় নিয়ামত অর্থাৎ সঠিক ও সরল পথের (হিদায়াত) প্রার্থনা জানাচ্ছে। যে পথ দুনিয়াতে শান্তি এবং আখিরাতে জান্নাতের দিকে নিয়ে যায়—অর্থাৎ ইসলামের সঠিক পথ বা নবী-রাসূলগণের দেখানো পথ।',
      7: '‘অনুগ্রহপ্রাপ্ত’ হলেন নবী, সিদ্দীক, শহীদ ও নেককার বান্দাগণ। ‘গজবপ্রাপ্ত’ (আল-মাগদুব) হলো তারা, যারা সত্য জানার পরও তা অস্বীকার করেছে বা অনুযায়ী আমল করেনি। আর ‘পথভ্রষ্ট’ (আদ-দাল্লিন) হলো তারা, যারা অজ্ঞতা ও ভুলের কারণে সঠিক পথ হারিয়ে ফেলেছে। এই আয়াতে তাদের পথ থেকে বেঁচে থাকার দোয়া করা হয়েছে।',
    };

    final tafsir = fatihaTafsir[ayahNumber];

    if (tafsir == null) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'সংক্ষিপ্ত তাফসির',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'তাফসির শীঘ্রই যোগ করা হবে।',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ঠিক আছে'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'সংক্ষিপ্ত তাফসির',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Text(
            tafsir,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A8754),
        foregroundColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFC9A227).withValues(alpha: 0.75),
              width: 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurahDistributionPage(
                    surah: widget.surah,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFFC9A227),
                    size: 19,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      _safeString(widget.surah.banglaName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'আরবি লেখা ছোট করুন',
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              setState(() {
                _arabicFontSize =
                    (_arabicFontSize - 2).clamp(22.0, 38.0);
              });
            },
          ),
          IconButton(
            tooltip: 'আরবি লেখা বড় করুন',
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              setState(() {
                _arabicFontSize =
                    (_arabicFontSize + 2).clamp(22.0, 38.0);
              });
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 52,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'কুরআনের তথ্য লোড করা যায়নি।',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: _load,
                          icon: const Icon(Icons.refresh),
                          label: const Text('আবার চেষ্টা করুন'),
                        ),
                      ],
                    ),
                  ),
                )
              : _ayahs.isEmpty
                  ? const Center(
                      child: Text(
                        'এই সূরার কোনো আয়াত পাওয়া যায়নি।',
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 24,
                            ),
                            itemCount: _ayahs.length,
                            itemBuilder: (context, index) {
                              return _buildAyah(index);
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  @override
  void dispose() {
    _lastReadTimer?.cancel();
    _itemPositionsListener.itemPositions.removeListener(
      _handleVisibleAyahChanged,
    );
    super.dispose();
  }
}
