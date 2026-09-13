import 'package:flutter/material.dart';

class AyahCard extends StatelessWidget {
  final int ayahNumber;
  final String arabicText;
  final String banglaText;
  final String? englishText;
  final double arabicFontSize;
  final double banglaFontSize;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onCopy;
  final VoidCallback? onPlayAudio;
  final VoidCallback? onShare;
  final VoidCallback? onTafsir;

  const AyahCard({
    super.key,
    required this.ayahNumber,
    required this.arabicText,
    required this.banglaText,
    this.englishText,
    this.arabicFontSize = 29,
    this.banglaFontSize = 17,
    this.isBookmarked = false,
    this.onBookmark,
    this.onCopy,
    this.onPlayAudio,
    this.onShare,
    this.onTafsir,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.colorScheme.primary;
    final darkGreen = theme.colorScheme.primary;
    final gold = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.colorScheme.onSurfaceVariant;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.fromLTRB(8, 1, 8, 2),
      shadowColor: green.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: green.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: gold.withValues(alpha: 0.75),
                      width: 1.4,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$ayahNumber',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.fromLTRB(4, 1, 4, 2),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: green.withValues(alpha: 0.10)),
                ),
              ),
              child: Text(
                arabicText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  height: 2.05,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.045),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                banglaText,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: banglaFontSize,
                  height: 1.85,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (englishText != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  englishText!,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onCopy != null)
                  _ActionButton(
                    tooltip: 'কপি',
                    icon: Icons.copy_outlined,
                    onPressed: onCopy!,
                  ),
                if (onBookmark != null)
                  _ActionButton(
                    tooltip: isBookmarked ? 'বুকমার্ক সরান' : 'বুকমার্ক',
                    icon: isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isBookmarked ? green : null,
                    onPressed: onBookmark!,
                  ),
                if (onShare != null)
                  _ActionButton(
                    tooltip: 'শেয়ার',
                    icon: Icons.share_outlined,
                    onPressed: onShare!,
                  ),
                if (onTafsir != null)
                  _ActionButton(
                    tooltip: 'সংক্ষিপ্ত তাফসির',
                    icon: Icons.menu_book_outlined,
                    onPressed: onTafsir!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.tooltip,
    required this.icon,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0A8754);

    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 21, color: color ?? green.withValues(alpha: 0.78)),
      onPressed: onPressed,
    );
  }
}
