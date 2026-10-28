import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';

class _CalendarEvent {
  const _CalendarEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.note,
    required this.reminder,
  });

  final String id;
  final String title;
  final DateTime dateTime;
  final String note;
  final bool reminder;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateTime': dateTime.toIso8601String(),
    'note': note,
    'reminder': reminder,
  };

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) {
    return _CalendarEvent(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      dateTime: DateTime.parse(json['dateTime'] as String),
      note: json['note'] as String? ?? '',
      reminder: json['reminder'] as bool? ?? false,
    );
  }
}

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  static const _storageKey = 'sirajum_calendar_personal_events_v1';
  static const _green = Color(0xFF0A8754);
  static const _gold = Color(0xFFC9A227);

  List<_CalendarEvent> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      final decoded = raw == null ? <dynamic>[] : jsonDecode(raw) as List;
      final events =
          decoded
              .map(
                (item) => _CalendarEvent.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList()
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (mounted) {
        setState(() {
          _events = events;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
        _message('সংরক্ষিত ইভেন্ট পড়া যায়নি।');
      }
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_events.map((event) => event.toJson()).toList()),
    );
  }

  int _notificationId(_CalendarEvent event) => int.parse(event.id) % 100000000;

  Future<void> _saveEvent(
    _CalendarEvent event, {
    _CalendarEvent? previous,
  }) async {
    try {
      if (previous != null && previous.reminder) {
        await NotificationService.instance.cancelCalendarEventReminder(
          _notificationId(previous),
        );
      }

      final index = _events.indexWhere((item) => item.id == event.id);
      setState(() {
        if (index == -1) {
          _events.add(event);
        } else {
          _events[index] = event;
        }
        _events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      });

      await _persist();

      var reminderScheduled = false;
      if (event.reminder) {
        reminderScheduled = await NotificationService.instance
            .scheduleCalendarEventReminder(
              eventId: _notificationId(event),
              title: '📅 ${event.title}',
              body: event.note.trim().isEmpty
                  ? 'আপনার নির্ধারিত ইভেন্টের সময় হয়েছে।'
                  : event.note,
              dateTime: event.dateTime,
            );
      }

      if (event.reminder && !reminderScheduled) {
        _message(
          'ইভেন্ট সংরক্ষিত। সময়টি পেরিয়ে গেছে, তাই রিমাইন্ডার সেট হয়নি।',
        );
      } else {
        _message(
          event.reminder
              ? 'ইভেন্ট সংরক্ষিত এবং রিমাইন্ডার সেট হয়েছে।'
              : 'ইভেন্ট সংরক্ষিত হয়েছে।',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Calendar event save/reminder failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _message(
        'ইভেন্ট সংরক্ষিত হয়েছে কি না যাচাই করুন; রিমাইন্ডার সেট নাও হতে পারে।',
      );
    }
  }

  Future<void> _deleteEvent(_CalendarEvent event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ইভেন্ট মুছবেন?'),
        content: Text('“${event.title}” মুছে ফেলা হবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('মুছুন'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      if (event.reminder) {
        await NotificationService.instance.cancelCalendarEventReminder(
          _notificationId(event),
        );
      }
      setState(() => _events.removeWhere((item) => item.id == event.id));
      await _persist();
      _message('ইভেন্ট মুছে ফেলা হয়েছে।');
    } catch (_) {
      _message('ইভেন্ট মুছতে সমস্যা হয়েছে।');
    }
  }

  Future<void> _editEvent([_CalendarEvent? existing]) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final noteController = TextEditingController(text: existing?.note ?? '');
    var selectedDate =
        existing?.dateTime ?? DateTime.now().add(const Duration(hours: 1));
    var selectedTime = TimeOfDay.fromDateTime(selectedDate);
    var reminder = existing?.reminder ?? true;

    final result = await showDialog<_CalendarEvent>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refreshDialog) => AlertDialog(
          title: Text(existing == null ? 'নতুন ইভেন্ট' : 'ইভেন্ট সম্পাদনা'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'ইভেন্টের নাম *',
                    hintText: 'যেমন: পারিবারিক অনুষ্ঠান',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      refreshDialog(
                        () => selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                      );
                    }
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.schedule),
                  label: Text(selectedTime.format(context)),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: dialogContext,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      refreshDialog(() {
                        selectedTime = picked;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                ),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'নোট (ঐচ্ছিক)',
                    alignLabelWithHint: true,
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: reminder,
                  onChanged: (value) =>
                      refreshDialog(() => reminder = value ?? false),
                  title: const Text('রিমাইন্ডার চালু'),
                  subtitle: const Text('নির্ধারিত সময় হলে নোটিফিকেশন'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('ইভেন্টের নাম লিখুন।')),
                  );
                  return;
                }
                final id =
                    existing?.id ??
                    DateTime.now().microsecondsSinceEpoch.toString();
                Navigator.pop(
                  dialogContext,
                  _CalendarEvent(
                    id: id,
                    title: title,
                    dateTime: selectedDate,
                    note: noteController.text.trim(),
                    reminder: reminder,
                  ),
                );
              },
              child: const Text('সংরক্ষণ'),
            ),
          ],
        ),
      ),
    );

    titleController.dispose();
    noteController.dispose();

    if (result != null) {
      await _saveEvent(result, previous: existing);
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _dateLabel(DateTime date) {
    const weekdays = [
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার',
      'রবিবার',
    ];
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} '
        '${months[date.month - 1]} ${date.year} • '
        '${TimeOfDay.fromDateTime(date).format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming = _events
        .where(
          (e) => !e.dateTime.isBefore(DateTime(now.year, now.month, now.day)),
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার ইভেন্ট'),
        foregroundColor: Colors.white,
        backgroundColor: _green,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editEvent(),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('ইভেন্ট যোগ'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.event_note_rounded,
                      size: 54,
                      color: _gold,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'এখনো কোনো ইভেন্ট নেই',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ব্যক্তিগত তারিখ, অনুষ্ঠান বা স্মরণিকা যোগ করুন। '
                      'ইভেন্টগুলো এই ডিভাইসে সংরক্ষিত থাকবে।',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _editEvent(),
                      icon: const Icon(Icons.add),
                      label: const Text('প্রথম ইভেন্ট যোগ করুন'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available, color: _green),
                      const SizedBox(width: 8),
                      Text(
                        'মোট ${_events.length}টি ইভেন্ট',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        'আসন্ন $upcoming',
                        style: const TextStyle(
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 6, 14, 90),
                    itemCount: _events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      final past = event.dateTime.isBefore(now);
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          leading: Container(
                            width: 44,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _green.withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.event, color: _green),
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_dateLabel(event.dateTime)),
                                if (event.note.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(event.note),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  past
                                      ? 'অতীতের ইভেন্ট'
                                      : event.reminder
                                      ? 'রিমাইন্ডার চালু'
                                      : 'রিমাইন্ডার বন্ধ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: past
                                        ? Colors.grey
                                        : event.reminder
                                        ? _green
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: event.note.isNotEmpty,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _editEvent(event);
                              if (value == 'delete') _deleteEvent(event);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('সম্পাদনা'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('মুছে ফেলুন'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
