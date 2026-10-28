import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SadaqahPage extends StatefulWidget {
  const SadaqahPage({super.key});

  @override
  State<SadaqahPage> createState() => _SadaqahPageState();
}

class _SadaqahPageState extends State<SadaqahPage> {
  static const _key = 'sirajum_sadaqah_records_v1';
  static const _green = Color(0xFF087A3B);
  static const _gold = Color(0xFFC9A227);
  static const _types = <String>[
    'সাধারণ সাদাকাহ',
    'সদকায়ে জারিয়া',
    'যাকাত',
    'ফিতরা',
  ];

  List<Map<String, dynamic>> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final records = <Map<String, dynamic>>[];
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map) {
              records.add(Map<String, dynamic>.from(item));
            }
          }
        }
      } catch (_) {
        // Keep the screen usable if an older saved value is malformed.
      }
    }
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_records));
  }

  double get _total => _records.fold<double>(
    0,
    (sum, record) => sum + ((record['amount'] as num?)?.toDouble() ?? 0),
  );

  String _money(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  Future<void> _addRecord() async {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String type = _types.first;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('দান যোগ করুন'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'দানের ধরন'),
                    items: _types
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => type = value);
                    },
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'পরিমাণ (টাকা)',
                      prefixText: '৳ ',
                    ),
                    validator: (value) {
                      final amount = double.tryParse((value ?? '').trim());
                      if (amount == null || !amount.isFinite || amount <= 0) {
                        return 'সঠিক পরিমাণ লিখুন';
                      }
                      return null;
                    },
                  ),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'বিবরণ (ঐচ্ছিক)',
                      hintText: 'যেমন: মসজিদ, অসহায় পরিবার',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, {
                  'type': type,
                  'amount': double.parse(amountController.text.trim()),
                  'note': noteController.text.trim(),
                  'date': DateTime.now().toIso8601String(),
                });
              },
              child: const Text('সংরক্ষণ'),
            ),
          ],
        ),
      ),
    );

    amountController.dispose();
    noteController.dispose();
    if (result == null || !mounted) return;

    setState(() {
      _records.insert(0, result);
    });
    await _saveRecords();
  }

  Future<void> _deleteRecord(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('রেকর্ড মুছবেন?'),
        content: const Text('এই দানের রেকর্ডটি মুছে যাবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('না'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('মুছুন'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _records.removeAt(index));
    await _saveRecords();
  }

  String _recordDate(dynamic raw) {
    final date = DateTime.tryParse(raw?.toString() ?? '')?.toLocal();
    if (date == null) return 'তারিখ নেই';
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সাদাকাহ ও দানের হিসাব'),
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecord,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('দান যোগ করুন'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.volunteer_activism,
                        color: _gold,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'সংরক্ষিত মোট দান',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '৳ ${_money(_total)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'মোট রেকর্ড: ${_records.length}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'দানের ধরন',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'সাদাকাহ, সদকায়ে জারিয়া, যাকাত ও ফিতরা এক বিষয় নয়। যাকাত ও ফিতরার পরিমাণ এবং প্রাপ্যতার বিধান নির্ভরযোগ্য আলেমের কাছ থেকে যাচাই করুন।',
                  style: TextStyle(height: 1.7),
                ),
                const SizedBox(height: 20),
                const Text(
                  'দানের ইতিহাস',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (_records.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long, size: 42, color: _gold),
                          SizedBox(height: 10),
                          Text('এখনো কোনো দানের হিসাব যোগ করা হয়নি।'),
                          SizedBox(height: 4),
                          Text('“দান যোগ করুন” চাপ দিয়ে শুরু করুন।'),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(_records.length, (index) {
                    final record = _records[index];
                    final amount = (record['amount'] as num?)?.toDouble() ?? 0;
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F3EB),
                          child: Icon(Icons.volunteer_activism, color: _green),
                        ),
                        title: Text(record['type']?.toString() ?? 'দান'),
                        subtitle: Text(
                          '${_recordDate(record['date'])}'
                          '${(record['note']?.toString().isNotEmpty ?? false) ? '\n${record['note']}' : ''}',
                        ),
                        isThreeLine:
                            (record['note']?.toString().isNotEmpty ?? false),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '৳ ${_money(amount)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _green,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                tooltip: 'রেকর্ড মুছুন',
                                onPressed: () => _deleteRecord(index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
