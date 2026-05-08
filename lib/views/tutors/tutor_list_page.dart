import 'package:flutter/material.dart';
import 'package:men2r_app/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/tutor_controller.dart';
import '../../controllers/subject_controller.dart';
import '../widgets/tutor_card.dart';
import '../widgets/app_drawer.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  final TextEditingController _searchController = TextEditingController();
  
  
  int? _selectedSubjectId;
  String _sortBy = 'LastName'; 
  String _sortOrder = 'asc';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorController>().fetchTutors();
      context.read<SubjectController>().fetchSubjects();
    });
  }

  void _refresh() {
    context.read<TutorController>().fetchTutors(
      subjectId: _selectedSubjectId,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSubjectId = null;
      _sortBy = 'LastName';
      _sortOrder = 'asc';
      _searchController.clear();
    });
    _refresh(); 
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context)!;  
    final subjects = context.read<SubjectController>().subjects;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.filter_sort_title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              
              DropdownButtonFormField<int>(
                value: _selectedSubjectId,
                decoration: InputDecoration(labelText: l10n.tutor_details_subjects),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Все предметы")),
                  ...subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                ],
                onChanged: (val) => setModalState(() => _selectedSubjectId = val),
              ),

              const SizedBox(height: 10),

              
              DropdownButtonFormField<String>(
                value: _sortBy,
                decoration: const InputDecoration(labelText: "Сортировать по"),
                items: const [
                  DropdownMenuItem(value: 'LastName', child: Text("Фамилии")),
                  DropdownMenuItem(value: 'Experience', child: Text("Опыту")),
                ],
                onChanged: (val) => setModalState(() => _sortBy = val!),
              ),

              const SizedBox(height: 10),

              
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.filter_sort_direction),
                trailing: ToggleButtons(
                  isSelected: [_sortOrder == 'asc', _sortOrder == 'desc'],
                  onPressed: (i) => setModalState(() => _sortOrder = i == 0 ? 'asc' : 'desc'),
                  children: const [Icon(Icons.arrow_upward), Icon(Icons.arrow_downward)],
                ),
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { 
                    _refresh(); 
                    Navigator.pop(context); 
                  },
                  child: Text(l10n.generic_save),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tutorCtrl = context.watch<TutorController>();
    final auth = context.watch<AuthController>();
    final bool isAdmin = auth.role == 'ADMIN';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tutor_list_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: "Сбросить фильтры",
            onPressed: _resetFilters,
          ),
          IconButton(
            icon: const Icon(Icons.tune), 
            onPressed: _showFilterSheet
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (val) => tutorCtrl.runSearch(val),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: tutorCtrl.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tutorCtrl.tutors.length,
                      itemBuilder: (ctx, i) => TutorCard(
                        tutor: tutorCtrl.tutors[i],
                        onTap: () => Navigator.pushNamed(
                          context, 
                          isAdmin ? '/tutor_form' : '/tutor_details', 
                          arguments: tutorCtrl.tutors[i]
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/tutor_add'), 
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}