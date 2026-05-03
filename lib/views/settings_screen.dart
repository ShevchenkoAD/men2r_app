import 'package:flutter/material.dart';
import 'package:men2r_app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import 'package:men2r_app/controllers/theme_controller.dart';
import 'package:men2r_app/controllers/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCtrl = Provider.of<ThemeController>(context);
    final localeCtrl = Provider.of<LocaleController>(context);
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings_title)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.settings_theme_title),
            value: themeCtrl.isDarkMode,
            onChanged: (val) => themeCtrl.toggleTheme(),
          ),
          ListTile(
            title: Text(l10n.settings_language),
            trailing: DropdownButton<String>(
              value: localeCtrl.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'ru', child: Text("Русский")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (val) => localeCtrl.setLocale(Locale(val!)),
            ),
          ),
          ListTile(
            title: Text(l10n.settings_role, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text(l10n.settings_role),
            subtitle: Text(auth.role ?? 'Unknown'), 
            leading: const Icon(Icons.verified_user),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(l10n.auth_logout, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
