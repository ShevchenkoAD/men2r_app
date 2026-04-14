import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/course.dart';
import '../../controllers/course_controller.dart';

class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
 final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _hoursCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  Course? _existing;
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Создаём контроллеры заранее (пустые)
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _hoursCtrl = TextEditingController();
    _startCtrl = TextEditingController();
    _endCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Course) {
        _existing = args;
        _titleCtrl.text = args.title;
        _descCtrl.text = args.description;
        _priceCtrl.text = args.price.toString();
        _hoursCtrl.text = args.hours.toString();
        if (args.startDate.isNotEmpty) {
          _startDate = DateTime.tryParse(args.startDate!);
        }
        if (args.endDate.isNotEmpty) {
          _endDate = DateTime.tryParse(args.endDate!);
        }
      } else {
        _startDate = DateTime.now();
        _endDate = DateTime.now().add(const Duration(days: 30));
      }

      _startCtrl.text = _startDate != null ? _dateFormat.format(_startDate!) : '';
      _endCtrl.text = _endDate != null ? _dateFormat.format(_endDate!) : '';
      
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _hoursCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    bool isStart,
    DateTime? current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startCtrl.text = _dateFormat.format(picked);

          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked.add(const Duration(days: 30));
            _endCtrl.text = _dateFormat.format(_endDate!);
          }
        } else {
          _endDate = picked;
          _endCtrl.text = _dateFormat.format(picked);
        }
      });
      _formKey.currentState?.validate();
    }
  }

  void _onSave() async {
    final startUtc = _startDate?.toUtc();
    final endUtc = _endDate?.toUtc();

    if (_formKey.currentState!.validate()) {
      final course = Course(
        serverId: _existing?.serverId ?? 0,
        title: _titleCtrl.text,
        description: _descCtrl.text,
        price: double.tryParse(_priceCtrl.text) ?? 0.0,
        hours: int.tryParse(_hoursCtrl.text) ?? 0,
        startDate: startUtc?.toIso8601String() ?? '',
        endDate: endUtc?.toIso8601String() ?? '',
        tutorId: _existing?.tutorId ?? 1,
      );

      final ctrl = context.read<CourseController>();
      final ok = _existing == null
          ? await ctrl.createCourse(course)
          : await ctrl.updateCourse(course);
      if (ok && mounted) Navigator.pop(context);
    }
  }

  void _onDelete() async {
    if (_existing != null) {
      await context.read<CourseController>().deleteCourse(_existing!.serverId);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_existing == null ? l10n.course_form_create_title : l10n.course_form_edit_title),
        actions: _existing != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _onDelete,
                )
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(  
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(labelText: l10n.course_details_title),
                    ),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: InputDecoration(labelText: l10n.course_details_description),
                      maxLines: 4,
                    
                    ),
                    TextFormField(
                      controller: _priceCtrl,
                      decoration: InputDecoration(labelText: l10n.course_details_price),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _hoursCtrl,
                      decoration: InputDecoration(labelText: l10n.course_details_hours),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _startCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.course_details_start_date,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, true, _startDate),       
                    ),
                    TextFormField(
                      controller: _endCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.course_details_end_date,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, false, _endDate),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(_existing == null ? l10n.generic_save : l10n.generic_edit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}