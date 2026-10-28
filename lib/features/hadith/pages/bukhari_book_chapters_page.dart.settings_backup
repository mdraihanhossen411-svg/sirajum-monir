import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/bukhari_ifa_book_01_data.dart';
import '../models/bukhari_book.dart';
import '../models/bukhari_hadith.dart';

class BukhariBookChaptersPage extends StatefulWidget {
  final BukhariBook book;

  const BukhariBookChaptersPage({
    super.key,
    required this.book,
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

  List<BukhariHadith> get _hadiths {
    if (widget.book.number == 1) {
      return BukhariIfaBook01Data.hadiths;
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
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
      ),
      body: _hadiths.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 32),
              itemCount: _hadiths.length,
              itemBuilder: (context, index) {
                final hadith = _hadiths[index];

                return _HadithCard(
                  hadith: hadith,
                  green: _green,
                  deepGreen: _deepGreen,
                  gold: _gold,
                  cream: _cream,
                  softGreen: _softGreen,
                  bookmarked: _bookmarked.contains(hadith.number),
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
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Card(
          elevation: 2,
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _deepGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.book.arabicName,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 18),
                const Text(
                  'এই কিতাবের হাদিসের ডাটা এখনো যুক্ত করা হয়নি।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HadithCard extends StatelessWidget {
  final BukhariHadith hadith;
  final Color green;
  final Color deepGreen;
  final Color gold;
  final Color cream;
  final Color softGreen;
  final bool bookmarked;
  final VoidCallback onBookmark;

  const _HadithCard({
    required this.hadith,
    required this.green,
    required this.deepGreen,
    required this.gold,
    required this.cream,
    required this.softGreen,
    required this.bookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 15),
            _buildArabic(),
            const SizedBox(height: 18),
            _buildBangla(),
            const SizedBox(height: 17),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'বোখারি শরিফ',
                      style: TextStyle(
                        color: Color(0xFF17231D),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _SahihButton(
                    green: green,
                    onTap: () => _showSahihHadith(context),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                'হাদিস ${_banglaDigits(hadith.number)}',
                style: TextStyle(
                  color: green,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        PopupMenuButton<String>(
          tooltip: 'আরও',
          icon: Icon(
            Icons.more_vert_rounded,
            color: deepGreen,
            size: 29,
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
      ],
    );
  }

  Widget _buildArabic() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F6),
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hadith.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 22,
              height: 2.05,
              color: Color(0xFF17231D),
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
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: softGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'বাংলা অনুবাদ',
            style: TextStyle(
              color: green,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hadith.bengali,
          style: const TextStyle(
            fontSize: 17,
            height: 1.75,
            color: Color(0xFF18211D),
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
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gold.withValues(alpha: .28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sticky_note_2_outlined,
            color: gold,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'নোট',
                  style: TextStyle(
                    color: deepGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hadith.note,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12.5,
                    height: 1.55,
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
      backgroundColor: Colors.white,
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
                const Text(
                  'যে হাদীসের সানাদ অবিচ্ছিন্ন হয়, বর্ণনাকারীরা ন্যায়পরায়ণ ও পূর্ণ আয়ত্বশক্তির অধিকারী হন এবং সানাদটি শা\'জ ও মু\'আল্লাল না হয় সে হাদীসকে সহীহ বা সহীহ লিযাতিহী। গ্রহণযোগ্য হাদীসগুলোর মধ্যে সহীহ লিযাতিহী\'র মর্যাদা সবচেয়ে বেশী ।',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Color(0xFF18211D),
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
          '''
বোখারি শরিফ
হাদিস ${_banglaDigits(hadith.number)}

আরবি:
${hadith.arabic}

বাংলা অনুবাদ:
${hadith.bengali}

নোট:
${hadith.note}
''',
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
            content: Text('লিঙ্ক শেয়ার ফিচার পরবর্তী ধাপে যুক্ত হবে।'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('রিপোর্ট ফিচার পরবর্তী ধাপে যুক্ত হবে।'),
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

  String _banglaDigits(int number) {
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

class _SahihButton extends StatelessWidget {
  final Color green;
  final VoidCallback onTap;

  const _SahihButton({
    required this.green,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: green,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          child: Text(
            'সহিহ হাদিস',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
