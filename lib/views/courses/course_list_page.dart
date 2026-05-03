import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/subject_controller.dart';
import '../../controllers/role_controller.dart';
import '../widgets/course_card.dart';
import '../widgets/app_drawer.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final TextEditingController _searchController = TextEditingController();
  
  
  int? _selectedSubjectId;
  RangeValues? _priceRange;
  RangeValues? _hoursRange;
  String _sortBy = 'Title'; 
  String _sortOrder = 'asc';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
      context.read<SubjectController>().fetchSubjects();
    });
  }

  void _applyFilters() {
    context.read<CourseController>().fetchCourses(
      subjectId: _selectedSubjectId,
      minPrice: _priceRange?.start,
      maxPrice: _priceRange?.end,
      minHours: _hoursRange?.start.toInt(),
      maxHours: _hoursRange?.end.toInt(),
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSubjectId = null;
      _priceRange = null; 
      _hoursRange = null;
      _sortBy = 'Title';
      _sortOrder = 'asc';
      _searchController.clear();
    });
    _applyFilters(); 
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context)!;
    final courseCtrl = context.read<CourseController>();
    final subjects = context.read<SubjectController>().subjects;

    
    double currentMaxPrice = courseCtrl.maxPriceInDb > 0 ? courseCtrl.maxPriceInDb : 100.0;
    double currentMaxHours = courseCtrl.maxHoursInDb > 0 ? courseCtrl.maxHoursInDb.toDouble() : 10.0;

    
    setState(() {
      if (_priceRange == null) {
        _priceRange = RangeValues(0, currentMaxPrice);
      } else {
        
        _priceRange = RangeValues(
          _priceRange!.start.clamp(0.0, currentMaxPrice),
          _priceRange!.end.clamp(0.0, currentMaxPrice),
        );
      }

      if (_hoursRange == null) {
        _hoursRange = RangeValues(0, currentMaxHours);
      } else {
        _hoursRange = RangeValues(
          _hoursRange!.start.clamp(0.0, currentMaxHours),
          _hoursRange!.end.clamp(0.0, currentMaxHours),
        );
      }
    });

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

              
              DropdownButtonFormField<String>(
                value: _sortBy,
                decoration: const InputDecoration(labelText: "Сортировать по"),
                items: const [
                  DropdownMenuItem(value: 'Title', child: Text("Названию")),
                  DropdownMenuItem(value: 'Price', child: Text("Стоимости")),
                  DropdownMenuItem(value: 'Hours', child: Text("Длительности")),
                  DropdownMenuItem(value: 'StartDate', child: Text("Дате начала")),
                ],
                onChanged: (val) => setModalState(() => _sortBy = val!),
              ),

              const SizedBox(height: 20),

              
              Text("${l10n.course_details_price}: ${_priceRange!.start.toInt()} - ${_priceRange!.end.toInt()}"),
              RangeSlider(
                values: _priceRange!,
                min: 0, 
                max: courseCtrl.maxPriceInDb > 0 ? courseCtrl.maxPriceInDb : 1000,
                onChanged: (v) => setModalState(() => _priceRange = v),
              ),

              
              Text("${l10n.course_details_hours}: ${_hoursRange!.start.toInt()} - ${_hoursRange!.end.toInt()}"),
              RangeSlider(
                values: _hoursRange!,
                min: 0, 
                max: courseCtrl.maxHoursInDb > 0 ? courseCtrl.maxHoursInDb.toDouble() : 100,
                onChanged: (v) => setModalState(() => _hoursRange = v),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.filter_sort_direction),
                  ToggleButtons(
                    isSelected: [_sortOrder == 'asc', _sortOrder == 'desc'],
                    onPressed: (i) => setModalState(() => _sortOrder = i == 0 ? 'asc' : 'desc'),
                    children: const [Icon(Icons.arrow_upward), Icon(Icons.arrow_downward)],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { _applyFilters(); Navigator.pop(context); },
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
    final courseCtrl = context.watch<CourseController>();
    final roleCtrl = context.watch<RoleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.course_list_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
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
              onChanged: (val) => courseCtrl.runSearch(val),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _applyFilters(),
              child: courseCtrl.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: courseCtrl.courses.length,
                      itemBuilder: (context, index) => CourseCard(
                        course: courseCtrl.courses[index],
                        onTap: () => Navigator.pushNamed(
                          context, 
                          roleCtrl.isAdmin ? '/course_form' : '/course_details', 
                          arguments: courseCtrl.courses[index]
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: roleCtrl.isAdmin
          ? FloatingActionButton(onPressed: () => Navigator.pushNamed(context, '/course_add'), child: const Icon(Icons.add))
          : null,
    );
  }
}