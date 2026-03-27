import 'package:flutter/material.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/tutor.dart';

class TutorDetailsScreen extends StatelessWidget {
  const TutorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutor = ModalRoute.of(context)!.settings.arguments as Tutor;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tutor_details_screen_title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: CircleAvatar(radius: 50, child: Text(tutor.lastname[0], style: const TextStyle(fontSize: 40)))),
            const SizedBox(height: 20),
            Text("${tutor.firstname} ${tutor.lastname} ${tutor.patronymic ?? ''}", 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(leading: Icon(Icons.history), title: Text(l10n.tutor_details_experience), subtitle: Text("${tutor.experience} ${l10n.generic_time_years}")),
            ListTile(leading: Icon(Icons.subject), title: Text(l10n.tutor_details_subjects), subtitle: Text(tutor.subjects)),
            const SizedBox(height: 10),
            Text(l10n.tutor_details_description, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tutor.description),
          ],
        ),
      ),
    );
  }
}