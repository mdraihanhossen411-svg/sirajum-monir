import 'package:flutter/material.dart';

import '../../../app/theme/theme_controller.dart';
import '../../prayer/controllers/prayer_notification_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ThemeController _themeController = ThemeController.instance;
  final PrayerNotificationController _prayerNotificationController =
      PrayerNotificationController();

  bool _prayerNotificationsEnabled = true;
  bool _loadingPrayerNotification = true;

  final Map<int, bool> _prayerEnabled = {
    1: true,
    2: true,
    3: true,
    4: true,
    5: true,
  };

  static const Map<int, String> _prayerNames = {
    1: 'ফজর',
    2: 'যোহর',
    3: 'আসর',
    4: 'মাগরিব',
    5: 'এশা',
  };

  @override
  void initState() {
    super.initState();
    _loadPrayerNotificationSetting();
  }

  Future<void> _loadPrayerNotificationSetting() async {
    final enabled =
        await _prayerNotificationController.isEnabled();

    final prayerSettings = <int, bool>{};

    for (final prayerType in _prayerNames.keys) {
      prayerSettings[prayerType] =
          await _prayerNotificationController.isPrayerEnabled(
        prayerType,
      );
    }

    if (!mounted) return;

    setState(() {
      _prayerNotificationsEnabled = enabled;
      _prayerEnabled
        ..clear()
        ..addAll(prayerSettings);
      _loadingPrayerNotification = false;
    });
  }

  Future<void> _togglePrayerNotification(bool value) async {
    setState(() {
      _prayerNotificationsEnabled = value;
    });

    try {
      await _prayerNotificationController.setEnabled(value);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'নামাজের সময়ের notification চালু হয়েছে'
                : 'নামাজের সময়ের notification বন্ধ হয়েছে',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _prayerNotificationsEnabled = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification setting পরিবর্তন করা যায়নি',
          ),
        ),
      );
    }
  }

  Future<void> _toggleIndividualPrayer(
    int prayerType,
    bool value,
  ) async {
    setState(() {
      _prayerEnabled[prayerType] = value;
    });

    try {
      await _prayerNotificationController.setPrayerEnabled(
        prayerType,
        value,
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _prayerEnabled[prayerType] = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'নামাজের notification setting পরিবর্তন করা যায়নি',
          ),
        ),
      );
    }
  }

  void _openSection(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _SettingsSectionPage(
          title: title,
          icon: icon,
        ),
      ),
    );
  }

  Widget _sectionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
        onTap: () => _openSection(
          context,
          title,
          icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _themeController,
        builder: (context, _) {
          final currentMode = _themeController.themeMode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'দেখানো ও থিম',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text(
                        'অ্যাপের থিম',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Light, Dark অথবা System থিম নির্বাচন করুন',
                      ),
                    ),
                    const Divider(height: 1),
                    RadioGroup<ThemeMode>(
                      groupValue: currentMode,
                      onChanged: (value) {
                        if (value != null) {
                          _themeController.setThemeMode(value);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.light,
                            title: const Text('Light Mode'),
                            subtitle: const Text('হালকা থিম'),
                            secondary: const Icon(
                              Icons.light_mode_rounded,
                            ),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.dark,
                            title: const Text('Dark Mode'),
                            subtitle: const Text('ডার্ক থিম'),
                            secondary: const Icon(
                              Icons.dark_mode_rounded,
                            ),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.system,
                            title: const Text('System Default'),
                            subtitle: const Text(
                              'ফোনের থিম অনুযায়ী পরিবর্তন হবে',
                            ),
                            secondary: const Icon(
                              Icons.settings_brightness_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'নামাজের Notification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.notifications_active_outlined,
                      ),
                      title: const Text(
                        'নামাজের সময়ের Notification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'পাঁচ ওয়াক্তের notification নিয়ন্ত্রণ করুন',
                      ),
                      value: _prayerNotificationsEnabled,
                      onChanged: _loadingPrayerNotification
                          ? null
                          : _togglePrayerNotification,
                    ),
                    if (_prayerNotificationsEnabled &&
                        !_loadingPrayerNotification) ...[
                      const Divider(height: 1),
                      for (final entry in _prayerNames.entries)
                        SwitchListTile(
                          contentPadding:
                              const EdgeInsets.only(
                            left: 24,
                            right: 16,
                          ),
                          secondary: const Icon(
                            Icons.mosque_outlined,
                            size: 21,
                          ),
                          title: Text('${entry.value} নামাজ'),
                          subtitle: const Text(
                            'নামাজের সময় notification',
                          ),
                          value:
                              _prayerEnabled[entry.key] ?? true,
                          onChanged: (value) {
                            _toggleIndividualPrayer(
                              entry.key,
                              value,
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'অন্যান্য সেটিংস',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              _sectionTile(
                context,
                title: 'Font & Text',
                subtitle: 'ফন্ট সাইজ ও লেখা প্রদর্শন',
                icon: Icons.text_fields_rounded,
              ),
              _sectionTile(
                context,
                title: 'Notification Settings',
                subtitle: 'সাধারণ notification নিয়ন্ত্রণ',
                icon: Icons.notifications_outlined,
              ),
              _sectionTile(
                context,
                title: 'Prayer Settings',
                subtitle: 'নামাজের সময় ও পদ্ধতি',
                icon: Icons.mosque_outlined,
              ),
              _sectionTile(
                context,
                title: 'Location',
                subtitle: 'শহর, জেলা ও অবস্থান',
                icon: Icons.location_on_outlined,
              ),
              _sectionTile(
                context,
                title: 'Calendar Settings',
                subtitle: 'ইসলামিক ও হিজরি ক্যালেন্ডার',
                icon: Icons.calendar_month_outlined,
              ),
              _sectionTile(
                context,
                title: 'Quran Settings',
                subtitle: 'কুরআন পড়ার প্রদর্শন সেটিংস',
                icon: Icons.menu_book_outlined,
              ),
              _sectionTile(
                context,
                title: 'Audio Settings',
                subtitle: 'অডিও কুরআন ও প্লেব্যাক',
                icon: Icons.headphones_outlined,
              ),
              _sectionTile(
                context,
                title: 'Local Data',
                subtitle: 'অ্যাপের স্থানীয় সংরক্ষিত তথ্য',
                icon: Icons.storage_outlined,
              ),
              _sectionTile(
                context,
                title: 'Backup & Restore',
                subtitle: 'ব্যাকআপ ও তথ্য পুনরুদ্ধার',
                icon: Icons.backup_outlined,
              ),
              _sectionTile(
                context,
                title: 'Language',
                subtitle: 'অ্যাপের ভাষা নির্বাচন',
                icon: Icons.language_outlined,
              ),
              _sectionTile(
                context,
                title: 'Privacy',
                subtitle: 'গোপনীয়তা ও তথ্য ব্যবস্থাপনা',
                icon: Icons.privacy_tip_outlined,
              ),
              _sectionTile(
                context,
                title: 'About & App Information',
                subtitle: 'অ্যাপ, সংস্করণ ও তথ্য',
                icon: Icons.info_outline_rounded,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsSectionPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SettingsSectionPage({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 52,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'এই অংশের প্রকৃত functionality পরবর্তী Data & Functionality Phase-এ যুক্ত হবে।',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
