
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bukhari_hadith.dart';

class BukhariHadithDetailPage extends StatefulWidget {
  final BukhariHadith hadith;

  const BukhariHadithDetailPage({
    super.key,
    required this.hadith,
  });

  @override
  State<BukhariHadithDetailPage> createState() =>
      _BukhariHadithDetailPageState();
}

class _BukhariHadithDetailPageState
    extends State<BukhariHadithDetailPage> {
  static const _green = Color(0xFF087A3B);
  static const _gold = Color(0xFFC9A227);

  double _fontScale = 1.0;
  bool _favorite = false;
  bool _bookmark = false;

  String _bnNumber(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((c) => bn[en.indexOf(c)])
        .join();
  }

  String get _favoriteKey => 'hadith_favorite_${widget.hadith.id}';
  String get _bookmarkKey => 'hadith_bookmark_${widget.hadith.id}';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _favorite = prefs.getBool(_favoriteKey) ?? false;
      _bookmark = prefs.getBool(_bookmarkKey) ?? false;
      _fontScale = prefs.getDouble('hadith_font_scale') ?? 1.0;
    });
  }

  Future<void> _setFontScale(double value) async {
    final scale = value.clamp(0.82, 1.28).toDouble();

    setState(() {
      _fontScale = scale;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hadith_font_scale', scale);
  }

  Future<void> _toggleFavorite() async {
    final value = !_favorite;

    setState(() {
      _favorite = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_favoriteKey, value);
  }

  Future<void> _toggleBookmark() async {
    final value = !_bookmark;

    setState(() {
      _bookmark = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bookmarkKey, value);
  }

  Future<void> _copyHadith() async {
    final text = [
      'হাদিস নং ${_bnNumber(widget.hadith.number)}',
      widget.hadith.arabic,
      widget.hadith.bengali,
    ].where((e) => e.trim().isNotEmpty).join('\n\n');

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('হাদিস কপি হয়েছে'),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _showExplanation() {
    if (widget.hadith.note.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('এই হাদিসের ব্যাখ্যা এখনো যুক্ত হয়নি'),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
            child: SingleChildScrollView(
              child: Text(
                widget.hadith.note,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return Expanded(
      child: Material(
        color: active
            ? _gold.withValues(alpha: 0.14)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: active ? _gold : _green,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: active ? _gold : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hadith = widget.hadith;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'হাদিস ${_bnNumber(hadith.number)}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'ফন্ট ছোট করুন',
            onPressed: () => _setFontScale(_fontScale - 0.08),
            icon: const Text(
              'A−',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            tooltip: 'ফন্ট বড় করুন',
            onPressed: () => _setFontScale(_fontScale + 0.08),
            icon: const Text(
              'A+',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
        children: [
          // ───── হাদিস নম্বর ─────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'হাদিস নং ${_bnNumber(hadith.number)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (hadith.internationalNumber.trim().isNotEmpty)
                Text(
                  'আন্তর্জাতিকঃ ${hadith.internationalNumber}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ───── Arabic ─────
          if (hadith.arabic.trim().isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                hadith.arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20 * _fontScale,
                  height: 1.95,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 10),

          // ───── Bengali ─────
          if (hadith.bengali.trim().isNotEmpty)
            Text(
              hadith.bengali,
              style: TextStyle(
                fontSize: 15 * _fontScale,
                height: 1.72,
                fontWeight: FontWeight.w400,
              ),
            ),

          const SizedBox(height: 11),

          // ───── ছোট Action Bar ─────
          Row(
            children: [
              _actionButton(
                icon: Icons.verified_outlined,
                label: 'মান',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(hadith.grade),
                      duration: const Duration(milliseconds: 1200),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              _actionButton(
                icon: Icons.copy_outlined,
                label: 'কপি',
                onTap: _copyHadith,
              ),
              const SizedBox(width: 6),
              _actionButton(
                icon: _bookmark
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                label: 'বুকমার্ক',
                active: _bookmark,
                onTap: _toggleBookmark,
              ),
              const SizedBox(width: 6),
              _actionButton(
                icon: _favorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: 'প্রিয়',
                active: _favorite,
                onTap: _toggleFavorite,
              ),
              const SizedBox(width: 6),
              _actionButton(
                icon: Icons.menu_book_outlined,
                label: 'ব্যাখ্যা',
                onTap: _showExplanation,
              ),
            ],
          ),

          // ───── তাহকীক / নোট ─────
          if (hadith.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _gold.withValues(alpha: 0.45),
                  ),
                ),
              ),
              child: Text(
                hadith.note,
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.55,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
