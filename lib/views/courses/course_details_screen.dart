import 'package:flutter/material.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/course.dart';
import '../../models/services/notification_service.dart'; 
import 'package:share_plus/share_plus.dart'; 

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    final l10n = AppLocalizations.of(context)!;
    final NotificationService _notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.course_details_screen_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
            
              final String message = l10n.share_course_text(
                course.hours.toString(), 
                course.price.toString(), 
                course.title,            
              );

              Share.share(message, subject: l10n.share_course_subject);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(l10n.course_details_date_period),
                subtitle: Text("${course.startDate.split('T')[0]} — ${course.endDate.split('T')[0]}"),
              ),
            ),
            const SizedBox(height: 15),
            Text(l10n.course_details_description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(course.description, style: const TextStyle(fontSize: 16)),
            const Divider(height: 30),
            Row(
              children: [
                Chip(label: Text("${course.hours} ${l10n.generic_time_hours}"), backgroundColor: Colors.blue.shade100),
                const Spacer(),
                Chip(label: Text("${course.price} ${l10n.generic_currency_byn}"), backgroundColor: Colors.green.shade100),
              ],
            ),
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _notificationService.scheduleCourseReminders(course);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.generic_succes_message)),
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: Text(l10n.generic_remind_message),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}