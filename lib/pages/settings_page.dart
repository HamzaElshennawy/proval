import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proval/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppThemeMode { system, light, dark }

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _launchGitHub() async {
    final url = Uri.parse('https://github.com/HamzaElshennawy/proval');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode currentMode = themeProvider.themeMode;

    AppThemeMode selectedMode;
    if (currentMode == ThemeMode.system) {
      selectedMode = AppThemeMode.system;
    } else if (currentMode == ThemeMode.dark) {
      selectedMode = AppThemeMode.dark;
    } else {
      selectedMode = AppThemeMode.light;
    }

    void onThemeChanged(AppThemeMode? mode) {
      if (mode == AppThemeMode.system) {
        themeProvider.setThemeMode(ThemeMode.system);
      } else if (mode == AppThemeMode.dark) {
        themeProvider.setThemeMode(ThemeMode.dark);
      } else {
        themeProvider.setThemeMode(ThemeMode.light);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Theme", style: Theme.of(context).textTheme.titleMedium),
          RadioListTile<AppThemeMode>(
            title: const Text('System Default'),
            value: AppThemeMode.system,
            groupValue: selectedMode,
            onChanged: onThemeChanged,
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Light'),
            value: AppThemeMode.light,
            groupValue: selectedMode,
            onChanged: onThemeChanged,
          ),
          RadioListTile<AppThemeMode>(
            title: const Text('Dark'),
            value: AppThemeMode.dark,
            groupValue: selectedMode,
            onChanged: onThemeChanged,
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About ProVal",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "ProVal is a Valorant esports companion app. "
                    "Stay up to date with the latest matches, results, and news from the competitive Valorant scene.",
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _launchGitHub,
                    icon: const Icon(Icons.code),
                    label: const Text("View Source on GitHub"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
