import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../controllers/theme_controller.dart';
import '../controllers/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCtrl = Provider.of<ThemeController>(context);
    final localeCtrl = Provider.of<LocaleController>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.darkTheme),
            value: themeCtrl.isDarkMode,
            onChanged: (val) => themeCtrl.toggleTheme(),
          ),
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: localeCtrl.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'ru', child: Text("Русский")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (val) => localeCtrl.setLocale(Locale(val!)),
            ),
          )
        ],
      ),
    );
  }
}