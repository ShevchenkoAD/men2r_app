import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/role_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roleCtrl = context.watch<RoleController>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(roleCtrl.isAdmin ? l10n.settings_role_admin : l10n.settings_role_student),
            accountEmail: const Text("user@men2r.app"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(roleCtrl.isAdmin ? Icons.admin_panel_settings : Icons.person),
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