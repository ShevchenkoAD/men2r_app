import 'package:flutter/material.dart';
import 'package:men2r_app/views/widgets/course_card.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/role_controller.dart';
import '../widgets/app_drawer.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final courseCtrl = context.watch<CourseController>();
    final roleCtrl = context.watch<RoleController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.course_list_title)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => courseCtrl.fetchCourses(),
        child: courseCtrl.isLoading && courseCtrl.courses.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: courseCtrl.courses.length,
                itemBuilder: (context, index) {
                  final course = courseCtrl.courses[index];
                  return CourseCard(course: course, onTap: () {
                        if (roleCtrl.isAdmin) {
                          Navigator.pushNamed(context, '/course_form', arguments: course);
                        } else {
                          Navigator.pushNamed(context, '/course_details', arguments: course);
                        }
                      }, 
                    );
                },
              ),
      ),
      floatingActionButton: roleCtrl.isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/course_add'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}