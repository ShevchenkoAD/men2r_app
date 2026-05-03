import 'package:flutter/material.dart';
import 'package:men2r_app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthController>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(    
            accountName: Text(auth.userName ?? 'Guest'), 
            accountEmail: Text(auth.role ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                (auth.userName != null && auth.userName!.isNotEmpty)
                    ? auth.userName![0].toUpperCase()
                    : 'U',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(l10n.course_menu_title),
            onTap: () => Navigator.pushReplacementNamed(context, '/courses'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(l10n.tutor_menu_title),
            onTap: () => Navigator.pushReplacementNamed(context, '/tutors'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings_menu_title),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}