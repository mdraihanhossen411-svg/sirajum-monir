import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/dua_models.dart';

class DuaCard extends StatelessWidget {
  final DuaItem dua;
  final bool favorite;
  final VoidCallback onFavorite;

  const DuaCard({
    super.key,
    required this.dua,
    required this.favorite,
    required this.onFavorite,
  });

  static const green = Color(0xFF087A3B);
  static const gold = Color(0xFFC9A227);

  String get _shareText => [
    dua.title,
    '',
    dua.arabic,
    if (dua.pronunciation.trim().isNotEmpty) ...[
      '',
      'বাংলা উচ্চারণ: ${dua.pronunciation}',
    ],
    '',
    'অর্থ: ${dua.meaning}',
    '',
    'সূত্র: ${dua.source}',
  ].join('\n');

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _shareText));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('দোয়াটি কপি করা হয়েছে')));
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(text: _shareText, subject: dua.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dua.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        dua.category,
                        style: const TextStyle(color: green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: favorite
                      ? 'পছন্দের তালিকা থেকে বাদ দিন'
                      : 'পছন্দের তালিকায় রাখুন',
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 25, height: 1.9, color: green),
              ),
            ),
            if (dua.pronunciation.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'বাংলা উচ্চারণ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(dua.pronunciation, style: const TextStyle(height: 1.6)),
            ],
            const SizedBox(height: 12),
            const Text('অর্থ', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(dua.meaning, style: const TextStyle(height: 1.7)),
            const Divider(height: 24),
            Text(
              'সূত্র: ${dua.source}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copy(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('কপি'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share),
                    label: const Text('শেয়ার'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
