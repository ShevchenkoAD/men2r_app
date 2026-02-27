import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../controllers/db_controller.dart';
import 'widgets/course_card.dart';
import 'add_course_screen.dart';
import 'course_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbProvider = Provider.of<DbController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      body: dbProvider.courses.isEmpty
          ? Center(child: Text(l10n.emptyList))
          : ListView.builder(
              itemCount: dbProvider.courses.length,
              itemBuilder: (context, index) {
                final course = dbProvider.courses[index];
                return CourseCard(
                  course: course,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(course: course))),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCourseScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}