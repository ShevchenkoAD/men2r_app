import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/tutor.dart';
import '../../controllers/tutor_controller.dart';

class TutorFormScreen extends StatefulWidget {
  const TutorFormScreen({super.key});

  @override
  State<TutorFormScreen> createState() => _TutorFormScreenState();
}

class _TutorFormScreenState extends State<TutorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lastNameCtrl;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _patronymicCtrl;
  late TextEditingController _experienceCtrl;
  late TextEditingController _subjectsCtrl;
  late TextEditingController _descriptionCtrl;

  Tutor? _existing;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _lastNameCtrl = TextEditingController();
    _firstNameCtrl = TextEditingController();
    _patronymicCtrl = TextEditingController();
    _experienceCtrl = TextEditingController();
    _subjectsCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Tutor && _existing == null) {
      _existing = args;
      _lastNameCtrl.text = args.lastname;
      _firstNameCtrl.text = args.firstname;
      _patronymicCtrl.text = args.patronymic ?? '';
      _experienceCtrl.text = args.experience.toString();
      _subjectsCtrl.text = args.subjects;
      _descriptionCtrl.text = args.description;
    }
  }

  @override
  void dispose() {
    _lastNameCtrl.dispose();
    _firstNameCtrl.dispose();
    _patronymicCtrl.dispose();
    _experienceCtrl.dispose();
    _subjectsCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final tutor = Tutor(
        serverId: _existing?.serverId ?? 0,
        lastname: _lastNameCtrl.text.trim(),
        firstname: _firstNameCtrl.text.trim(),
        patronymic: _patronymicCtrl.text.trim().isEmpty ? null : _patronymicCtrl.text.trim(),
        experience: int.tryParse(_experienceCtrl.text) ?? 0,
        subjects: _subjectsCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
      );

      final ctrl = context.read<TutorController>();
      final ok = _existing == null
          ? await ctrl.addTutor(tutor)
          : await ctrl.updateTutor(tutor);

      if (ok && mounted) Navigator.pop(context);
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  void _onDelete() async {
    if (_existing != null) {
      await context.read<TutorController>().deleteTutor(_existing!.serverId);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l10n.tutor_form_create_title : l10n.tutor_form_edit_title),
        actions: _existing != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: _onDelete,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _lastNameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_lastname,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_firstname,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _patronymicCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_patronymic,
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_experience,
                  prefixIcon: Icon(Icons.work),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectsCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_subjects,
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tutor_details_description,
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              Expanded(child: const SizedBox(height: 0)),
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
    );
  }
}