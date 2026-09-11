import 'package:flutter/material.dart';
import '../models/quran_model.dart';
import '../services/bookmark_service.dart';
import 'surah_detail_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService _service = BookmarkService();
  List<Map<String, dynamic>> _bookmarks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _service.load();
    if (!mounted) return;

    setState(() {
      _bookmarks = data;
      _loading = false;
    });
  }

  Future<void> _remove(Map<String, dynamic> item) async {
    await _service.remove(
      item['surahId'] as int,
      item['ayahNumber'] as int,
    );
    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('বুকমার্ক মুছে ফেলা হয়েছে'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _open(Map<String, dynamic> item) async {
    final surah = SurahModel(
      id: item['surahId'] as int,
      arabicName: item['surahArabic'] as String? ?? '',
      englishName: item['surahEnglish'] as String? ?? '',
      banglaName: item['surahBangla'] as String? ?? '',
      totalAyah: item['totalAyah'] as int? ?? 0,
      revelationType: '',
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahDetailPage(
                        surah: surah,
                        initialAyah: item['ayahNumber'] as int,
                      ),
      ),
    );

    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookmarks.isEmpty) {
      return const Center(
        child: Text(
          'কোনো বুকমার্ক সংরক্ষিত নেই',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        final item = _bookmarks[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF0A8754),
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
            ),
            title: Text(
              '${item['surahBangla']} • আয়াত ${item['ayahNumber']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item['banglaText'] as String? ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              tooltip: 'মুছে ফেলুন',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _remove(item),
            ),
            onTap: () => _open(item),
          ),
        );
      },
    );
  }
}
