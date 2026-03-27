import 'package:flutter/material.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/course.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.course_details_screen_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(l10n.course_details_date_period),
                subtitle: Text("${course.startDate.split('T')[0]} — ${course.endDate.split('T')[0]}"),
              ),
            ),
            Text(l10n.course_details_description, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(course.description, style: const TextStyle(fontSize: 16)),
            const Divider(),
            Row(
              children: [
                Chip(label: Text("${course.hours} ${l10n.generic_time_hours}"), backgroundColor: Colors.blue.shade100),
                const Spacer(),
                Chip(label: Text("${course.price} ${l10n.generic_currency_byn}"), backgroundColor: Colors.green.shade100),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}