import 'package:flutter/material.dart';
import '../../../app/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস'), centerTitle: true),
      body: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          final currentMode = themeController.themeMode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text(
                        'অ্যাপের থিম',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'পুরো অ্যাপের Light, Dark অথবা System থিম নির্বাচন করুন',
                      ),
                    ),
                    const Divider(height: 1),
                    RadioGroup<ThemeMode>(
                      groupValue: currentMode,
                      onChanged: (value) {
                        if (value != null) themeController.setThemeMode(value);
                      },
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.light,
                            title: const Text('Light Mode'),
                            subtitle: const Text('হালকা থিম'),
                            secondary: const Icon(Icons.light_mode_rounded),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.dark,
                            title: const Text('Dark Mode'),
                            subtitle: const Text('ডার্ক থিম'),
                            secondary: const Icon(Icons.dark_mode_rounded),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.system,
                            title: const Text('System Default'),
                            subtitle: const Text(
                              'ফোনের থিম অনুযায়ী স্বয়ংক্রিয়ভাবে পরিবর্তন হবে',
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
            ],
          );
        },
      ),
    );
  }
}
