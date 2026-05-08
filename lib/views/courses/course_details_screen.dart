import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/course.dart';
import '../../models/tutor.dart';
import '../../controllers/tutor_controller.dart';
import '../../models/services/notification_service.dart'; 
import '../widgets/tutor_card.dart'; 
import 'package:share_plus/share_plus.dart'; 

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    final l10n = AppLocalizations.of(context)!;
    final NotificationService _notificationService = NotificationService();

    
    final tutorController = context.watch<TutorController>();
    Tutor? tutor;
    try {
      tutor = tutorController.tutors.firstWhere((t) => t.serverId == course.tutorId);
    } catch (e) {
      tutor = null;
    }

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
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(l10n.course_details_date_period, style: const TextStyle(fontSize: 14)),
                subtitle: Text("${course.startDate.split('T')[0]} — ${course.endDate.split('T')[0]}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
            ),
            
            const SizedBox(height: 20),
            Text(l10n.course_details_description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text(course.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Chip(
                  label: Text("${course.hours} ${l10n.generic_time_hours}"), 
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                const Spacer(),
                Chip(
                  label: Text("${course.price} ${l10n.generic_currency_byn}"), 
                  backgroundColor: Colors.green.shade50,
                  side: BorderSide(color: Colors.green.shade200),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(),
            ),

            
            Text(l10n.tutor_list_title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            if (tutor != null)
              TutorCard(
                tutor: tutor,
                onTap: () {
                  Navigator.pushNamed(context, '/tutor_details', arguments: tutor);
                },
              )
            else
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )),
            
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            await _notificationService.scheduleCourseReminders(course);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.generic_succes_message)),
              );
            }
          },
          icon: const Icon(Icons.notifications_active),
          label: Text(l10n.generic_remind_message),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}