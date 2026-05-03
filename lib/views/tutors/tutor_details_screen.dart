import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/tutor.dart';

class TutorDetailsScreen extends StatelessWidget {
  const TutorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutor = ModalRoute.of(context)!.settings.arguments as Tutor;
    final l10n = AppLocalizations.of(context)!;

    
    final String subjectsString = tutor.subjects != null 
        ? tutor.subjects!.map((s) => s.name).join(', ') 
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tutor_details_screen_title),
        actions : [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String fullName = "${tutor.firstname} ${tutor.lastname}";
              final String subjects = tutor.subjects?.map((s) => s.name).join(', ') ?? '';
              
              
              
              final String message = l10n.share_tutor_text(
                tutor.experience.toString(), 
                "$fullName",                 
                subjects,                    
              );

              Share.share(message, subject: l10n.share_tutor_subject);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: Hero(
                tag: 'tutor_photo_${tutor.serverId}',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: tutor.imageUrl != null && tutor.imageUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(tutor.imageUrl!)
                      : null,
                  child: tutor.imageUrl == null || tutor.imageUrl!.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.blue)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "${tutor.firstname} ${tutor.lastname} ${tutor.patronymic ?? ''}", 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: Text(l10n.tutor_details_experience),
              subtitle: Text("${tutor.experience} ${l10n.generic_time_years}"),
            ),
            ListTile(
              leading: const Icon(Icons.subject, color: Colors.blue),
              title: Text(l10n.tutor_details_subjects),
              subtitle: Text(subjectsString),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.tutor_details_description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(tutor.description, style: const TextStyle(fontSize: 15, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}