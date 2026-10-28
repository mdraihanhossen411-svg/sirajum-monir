import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/tasbih_controller.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  late final TasbihController controller;

  static const green = Color(0xFF0A8754);
  static const gold = Color(0xFFC9A227);

  @override
  void initState() {
    super.initState();
    controller = TasbihController();
    Future.microtask(() async {
      if (!mounted) return;
      await controller.init();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final item = controller.selected;

        return Scaffold(
          appBar: AppBar(
            title: const Text('যিকির ও আমল'),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: 'আমার যিকির',
                icon: const Icon(Icons.bookmark_outline),
                onPressed: _showMyZikr,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                _categoryBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: [
                        _zikrCard(item),
                        const SizedBox(height: 18),
                        _counterCard(),
                        const SizedBox(height: 12),
                        _dailyHistoryCard(),
                        const SizedBox(height: 12),
                        const SizedBox(height: 12),
                        const SizedBox(height: 16),
                        _targetSelector(),
                        const SizedBox(height: 14),
                        _actionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _categoryBar() {
    final categories = controller.all.map((e) => e.category).toSet().toList();

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final firstIndex = controller.all.indexWhere(
            (e) => e.category == category,
          );

          final selected = controller.selected.category == category;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            selectedColor: green.withValues(alpha: .15),
            side: BorderSide(
              color: selected ? green : Colors.grey.withValues(alpha: .3),
            ),
            labelStyle: TextStyle(
              color: selected ? green : null,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            onSelected: (_) {
              if (firstIndex >= 0) {
                controller.selectByIndex(firstIndex);
              }
            },
          );
        },
      ),
    );
  }

  Widget _zikrCard(dynamic item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: gold.withValues(alpha: .35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: green,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                item.arabic,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (item.pronunciation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                item.pronunciation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .72),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
            if (item.meaning.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.meaning,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _counterCard() {
    final progress = controller.progress.clamp(0.0, 1.0);
    final completed = controller.completed;
    final remaining = (controller.target - controller.count).clamp(
      0,
      controller.target,
    );
    final percent = (progress * 100).round();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.track_changes_rounded,
                  color: Color(0xFFC9A227),
                  size: 21,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'তাসবিহ কাউন্টার',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: completed
                        ? gold.withValues(alpha: .12)
                        : green.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percent%',
                    style: TextStyle(
                      color: completed ? gold : green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: completed ? null : _tapCounter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 246,
                height: 246,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                      color: Colors.black.withValues(alpha: .10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: green.withValues(alpha: .10),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          completed ? gold : green,
                        ),
                      ),
                    ),
                    Container(
                      width: 194,
                      height: 194,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: completed
                              ? gold.withValues(alpha: .35)
                              : green.withValues(alpha: .18),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.count}',
                            style: TextStyle(
                              fontSize: 56,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              color: completed ? gold : green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'লক্ষ্য ${controller.target}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .65),
                            ),
                          ),
                          if (!completed) ...[
                            const SizedBox(height: 5),
                            Text(
                              'আর $remaining বাকি',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: .55),
                              ),
                            ),
                          ],
                          if (completed)
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                'আলহামদুলিল্লাহ ✓',
                                style: TextStyle(
                                  color: gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              completed
                  ? 'লক্ষ্য পূর্ণ হয়েছে'
                  : 'গোলাকার কাউন্টারেও ট্যাপ করতে পারেন',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .60),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: completed ? null : _tapCounter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: completed
                        ? [gold.withValues(alpha: .75), gold]
                        : [green, const Color(0xFF087343)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                      color: Colors.black.withValues(alpha: .15),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        completed
                            ? Icons.check_circle_outline
                            : Icons.touch_app_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 9),
                      Text(
                        completed ? 'লক্ষ্য পূর্ণ হয়েছে' : 'যিকির গণনা করুন',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tapCounter() async {
    HapticFeedback.selectionClick();
    final before = controller.count;
    await controller.increment();

    if (controller.count > before && controller.completed && mounted) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('মাশাআল্লাহ! নির্ধারিত যিকির সম্পন্ন হয়েছে।'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _dailyHistoryCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.history_rounded, color: Color(0xFFC9A227)),
        title: const Text(
          'দৈনিক ইতিহাস',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: const Text('দিনভিত্তিক যিকিরের হিসাব দেখুন'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _showDailyHistory(),
      ),
    );
  }

  Future<void> _showDailyHistory() async {
    final history = await controller.getDailyHistory();
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.70,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: Color(0xFFC9A227),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'দৈনিক ইতিহাস',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                        tooltip: 'বন্ধ করুন',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'এখনও কোনো দৈনিক ইতিহাস নেই।\n'
                              'যিকির গণনা করলে এখানে হিসাব দেখা যাবে।',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                          itemCount: history.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final day = history[index];
                            final items = (day['items'] as List?) ?? const [];

                            return Card(
                              child: ExpansionTile(
                                leading: const Icon(Icons.calendar_today),
                                title: Text(day['date']?.toString() ?? ''),
                                subtitle: Text('মোট ${day['total'] ?? 0} বার'),
                                children: items.map<Widget>((rawItem) {
                                  final item = Map<String, dynamic>.from(
                                    rawItem as Map,
                                  );
                                  final arabic =
                                      item['arabic']?.toString() ?? '';

                                  return ListTile(
                                    title: Text(
                                      item['title']?.toString() ?? 'যিকির',
                                    ),
                                    subtitle: arabic.isEmpty
                                        ? null
                                        : Text(
                                            arabic,
                                            textDirection: TextDirection.rtl,
                                          ),
                                    trailing: Text('${item['count'] ?? 0} বার'),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _targetSelector() {
    const targets = [11, 33, 99, 100, 313, 1000];

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'যিকিরের লক্ষ্য',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...targets.map(
                  (value) => ChoiceChip(
                    label: Text('$value'),
                    selected: controller.target == value,
                    onSelected: (_) => controller.setTarget(value),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.edit, size: 17),
                  label: const Text('কাস্টম'),
                  onPressed: _customTarget,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _customTarget() async {
    String input = '${controller.target}';

    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('নিজের লক্ষ্য নির্ধারণ করুন'),
        content: TextField(
          keyboardType: TextInputType.number,
          autofocus: true,
          onChanged: (text) => input = text,
          decoration: const InputDecoration(
            labelText: 'লক্ষ্য',
            hintText: 'যেমন 500',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = int.tryParse(input.trim());
              if (parsed != null && parsed > 0) {
                Navigator.pop(dialogContext, parsed);
              }
            },
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (value != null) {
      await controller.setTarget(value);
    }
  }

  Widget _actionButtons() {
    Widget smallButton({
      required IconData icon,
      required VoidCallback? onPressed,
      required String tooltip,
    }) {
      return Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Icon(
                  icon,
                  size: 16,
                  color: onPressed == null
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        smallButton(
          icon: Icons.undo,
          onPressed: controller.count > 0 ? controller.undo : null,
          tooltip: 'পেছনে',
        ),
        const SizedBox(width: 7),
        smallButton(
          icon: Icons.restart_alt,
          onPressed: controller.count > 0 ? _confirmReset : null,
          tooltip: 'রিসেট',
        ),
        const SizedBox(width: 7),
        smallButton(
          icon: Icons.add,
          onPressed: _addZikr,
          tooltip: 'যিকির যোগ করুন',
        ),
      ],
    );
  }

  Future<void> _confirmReset() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('কাউন্টার রিসেট করবেন?'),
        content: const Text('এই যিকিরের বর্তমান গণনা ০ হয়ে যাবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (yes == true) {
      await controller.reset();
    }
  }

  Future<void> _addZikr() async {
    final title = TextEditingController();
    final arabic = TextEditingController();
    final pronunciation = TextEditingController();
    final meaning = TextEditingController();
    final target = TextEditingController(text: '33');

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'নিজের যিকির সংরক্ষণ করুন',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: 'যিকিরের নাম *'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: arabic,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(labelText: 'আরবি'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pronunciation,
                  decoration: const InputDecoration(labelText: 'উচ্চারণ'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: meaning,
                  decoration: const InputDecoration(labelText: 'অর্থ'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: target,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'লক্ষ্য'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (title.text.trim().isEmpty) return;
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('সংরক্ষণ করুন'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      final targetValue = int.tryParse(target.text.trim()) ?? 33;

      await controller.addCustom(
        title: title.text,
        arabic: arabic.text,
        pronunciation: pronunciation.text,
        meaning: meaning.text,
        target: targetValue,
      );
    }

    title.dispose();
    arabic.dispose();
    pronunciation.dispose();
    meaning.dispose();
    target.dispose();
  }

  void _showMyZikr() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.90,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (_, child) {
                  final items = controller.custom;

                  if (items.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Icon(
                          Icons.bookmark_border_rounded,
                          size: 54,
                          color: Color(0xFFC9A227),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'এখনও কোনো নিজের যিকির সংরক্ষণ করা হয়নি।',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            _addZikr();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('যিকির যোগ করুন'),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bookmark_rounded,
                              color: Color(0xFFC9A227),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'আমার যিকির',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'নতুন যিকির',
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                _addZikr();
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: items.length,
                          separatorBuilder: (_, child) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final item = items[index];
                            final absoluteIndex =
                                controller.builtIn.length + index;
                            final selected =
                                controller.selectedIndex == absoluteIndex;

                            return Card(
                              margin: EdgeInsets.zero,
                              child: ListTile(
                                onTap: () {
                                  controller.selectByIndex(absoluteIndex);
                                  Navigator.pop(sheetContext);
                                },
                                leading: CircleAvatar(
                                  backgroundColor: selected
                                      ? const Color(0xFF0A8754)
                                      : const Color(0xFFE8F5EE),
                                  child: Icon(
                                    selected
                                        ? Icons.check
                                        : Icons.favorite_rounded,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF0A8754),
                                  ),
                                ),
                                title: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${item.count} / ${item.defaultTarget}',
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.pop(sheetContext);
                                      await _editZikr(index);
                                    } else if (value == 'delete') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            title: const Text(
                                              'যিকির মুছে ফেলবেন?',
                                            ),
                                            content: Text(
                                              '“${item.title}” মুছে ফেলা হবে।',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  dialogContext,
                                                  false,
                                                ),
                                                child: const Text('না'),
                                              ),
                                              FilledButton(
                                                onPressed: () => Navigator.pop(
                                                  dialogContext,
                                                  true,
                                                ),
                                                child: const Text('মুছুন'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirm == true) {
                                        await controller.deleteCustom(index);
                                      }
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('সম্পাদনা'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('মুছুন'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _editZikr(int index) async {
    if (index < 0 || index >= controller.custom.length) return;

    final item = controller.custom[index];

    final titleController = TextEditingController(text: item.title);
    final arabicController = TextEditingController(text: item.arabic);
    final pronunciationController = TextEditingController(
      text: item.pronunciation,
    );
    final meaningController = TextEditingController(text: item.meaning);
    final targetController = TextEditingController(
      text: item.defaultTarget.toString(),
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'যিকির সম্পাদনা করুন',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'যিকিরের নাম',
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: arabicController,
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      labelText: 'আরবি',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pronunciationController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'উচ্চারণ',
                      prefixIcon: Icon(Icons.record_voice_over_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: meaningController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'অর্থ',
                      prefixIcon: Icon(Icons.translate),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'লক্ষ্য সংখ্যা',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final target =
                            int.tryParse(targetController.text.trim()) ?? 0;

                        if (titleController.text.trim().isEmpty ||
                            target <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'যিকিরের নাম ও সঠিক লক্ষ্য সংখ্যা দিন।',
                              ),
                            ),
                          );
                          return;
                        }

                        await controller.updateCustom(
                          index: index,
                          title: titleController.text,
                          arabic: arabicController.text,
                          pronunciation: pronunciationController.text,
                          meaning: meaningController.text,
                          target: target,
                        );

                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('পরিবর্তন সংরক্ষণ'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    arabicController.dispose();
    pronunciationController.dispose();
    meaningController.dispose();
    targetController.dispose();
  }
}
