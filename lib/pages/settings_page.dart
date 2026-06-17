import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/repositories/settings_repo.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsRepository _settings = GetIt.I.get<SettingsRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text('Dunkles Theme'),
            subtitle: Text(
              'Wird nach einem Neustart übernommen',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            value: _settings.themeMode == ThemeMode.dark,
            onChanged: _onChangeTheme,
          ),
          const Divider(),
          ListTile(
            title: const Text('Einstellungen zurücksetzen'),
            onTap: () => _settings.clear(),
          ),
          const Divider(),
          ListTile(
              title: const Text('Über diese App'),
              onTap: () async {
                final info = await PackageInfo.fromPlatform();
                if (!mounted) return;
                showAboutDialog(
                  context: context,
                  applicationName: 'DeliveryWare',
                  applicationVersion: info.version,
                  applicationLegalese: '© ${DateTime.now().year} DeliveryWare',
                );
              }),
        ],
      ),
    );
  }

  void _onChangeTheme(bool? value) {
    setState(
      () => value ?? false
          ? _settings.themeMode = ThemeMode.dark
          : _settings.themeMode = ThemeMode.light,
    );
  }
}
