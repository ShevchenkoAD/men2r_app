import 'package:flutter/material.dart';
import 'package:men2r_app/views/widgets/tutor_card.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/tutor_controller.dart';
import '../../controllers/role_controller.dart';
import '../widgets/app_drawer.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorController>().fetchTutors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tutorCtrl = context.watch<TutorController>();
    final roleCtrl = context.watch<RoleController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tutor_list_title)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => tutorCtrl.fetchTutors(),
        child: tutorCtrl.isLoading && tutorCtrl.tutors.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: tutorCtrl.tutors.length,
                itemBuilder: (context, index) {
                  final tutor = tutorCtrl.tutors[index];
                  return TutorCard(tutor: tutor, onTap: () { 
                        if (roleCtrl.isAdmin) {
                          Navigator.pushNamed(context, '/tutor_form', arguments: tutor);
                        } else {
                          Navigator.pushNamed(context, '/tutor_details', arguments: tutor);
                        }
                      },
                  );
                },
              ),
      ),
      
      floatingActionButton: roleCtrl.isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/tutor_add'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}