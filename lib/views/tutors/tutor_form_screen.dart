import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../models/tutor.dart';
import '../../controllers/tutor_controller.dart';
import '../../controllers/subject_controller.dart';

class TutorFormScreen extends StatefulWidget {
  const TutorFormScreen({super.key});

  @override
  State<TutorFormScreen> createState() => _TutorFormScreenState();
}

class _TutorFormScreenState extends State<TutorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lastNameCtrl, _firstNameCtrl, _patronymicCtrl, _experienceCtrl, _descriptionCtrl;

  Tutor? _existing;
  File? _selectedImage;
  List<int> _selectedSubjectIds = [];

  @override
  void initState() {
    super.initState();
    _lastNameCtrl = TextEditingController();
    _firstNameCtrl = TextEditingController();
    _patronymicCtrl = TextEditingController();
    _experienceCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectController>().fetchSubjects();
    });
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
      _descriptionCtrl.text = args.description;
      _selectedSubjectIds = args.subjects?.map((s) => s.id).toList() ?? [];
    }
  }

  @override
  void dispose() {
    _lastNameCtrl.dispose(); _firstNameCtrl.dispose(); _patronymicCtrl.dispose();
    _experienceCtrl.dispose(); _descriptionCtrl.dispose();
    super.dispose();
  }

Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source, 
      imageQuality: 70, 
      maxWidth: 1000,  
    );
    
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }

void _showPhotoOptions() {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(l10n.image_source_camera),
          onTap: () => _pickImage(ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: Text(l10n.image_source_gallery),
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

  
  void _showSubjectSelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allSubjects = context.read<SubjectController>().subjects;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( 
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.tutor_details_subjects),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allSubjects.length,
                  itemBuilder: (ctx, i) {
                    final sub = allSubjects[i];
                    return CheckboxListTile(
                      title: Text(sub.name),
                      value: _selectedSubjectIds.contains(sub.id),
                      onChanged: (bool? checked) {
                        setDialogState(() {
                          if (checked == true) {
                            _selectedSubjectIds.add(sub.id);
                          } else {
                            _selectedSubjectIds.remove(sub.id);
                          }
                        });
                        setState(() {}); 
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.generic_save),
                ),
              ],
            );
          },
        );
      },
    );
  }

void _onSave() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_selectedSubjectIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.generic_field_required_error)),
        );
        return;
      }

      final tutor = Tutor(
        serverId: _existing?.serverId ?? 0,
        lastname: _lastNameCtrl.text.trim(),
        firstname: _firstNameCtrl.text.trim(),
        patronymic: _patronymicCtrl.text.trim().isEmpty ? null : _patronymicCtrl.text.trim(),
        experience: int.tryParse(_experienceCtrl.text) ?? 0,
        description: _descriptionCtrl.text.trim(),
        imageUrl: _existing?.imageUrl, 
      );

      final ctrl = context.read<TutorController>();
      
      
      final ok = _existing == null 
          ? await ctrl.addTutor(tutor, _selectedSubjectIds, _selectedImage)
          : await ctrl.updateTutor(tutor, _selectedSubjectIds, _selectedImage);

      if (ok && mounted) Navigator.pop(context);
    }
  }

  @override
    @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l10n.tutor_form_create_title : l10n.tutor_form_edit_title),
        actions: _existing != null ? [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red), 
            onPressed: () => context.read<TutorController>().deleteTutor(_existing!.serverId).then((_) => Navigator.pop(context))
          )
        ] : null,
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
                    
                    GestureDetector(
                      onTap: _showPhotoOptions,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _selectedImage != null 
                            ? FileImage(_selectedImage!) 
                            : (_existing?.imageUrl != null ? NetworkImage(_existing!.imageUrl!) : null) as ImageProvider?,
                        child: (_selectedImage == null && _existing?.imageUrl == null) 
                            ? const Icon(Icons.add_a_photo, size: 30) 
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    
                    TextFormField(
                      controller: _lastNameCtrl, 
                      decoration: InputDecoration(labelText: l10n.tutor_details_lastname, prefixIcon: const Icon(Icons.person))
                    ),
                    const SizedBox(height: 12),
                    
                    
                    TextFormField(
                      controller: _firstNameCtrl, 
                      decoration: InputDecoration(labelText: l10n.tutor_details_firstname, prefixIcon: const Icon(Icons.person))
                    ),
                    const SizedBox(height: 12),

                    
                    TextFormField(
                      controller: _patronymicCtrl, 
                      decoration: InputDecoration(
                        labelText: l10n.tutor_details_patronymic, 
                        prefixIcon: const Icon(Icons.person_outline)
                      )
                    ),
                    const SizedBox(height: 12),
                    
                    
                    TextFormField(
                      controller: _experienceCtrl, 
                      decoration: InputDecoration(labelText: l10n.tutor_details_experience, prefixIcon: const Icon(Icons.work)), 
                      keyboardType: TextInputType.number
                    ),
                    
                    const SizedBox(height: 20),
                    
                    
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.tutor_details_subjects, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_selectedSubjectIds.isEmpty 
                          ? l10n.tutor_form_select_subject_title
                          : "${l10n.tutor_form_subject_count}: ${_selectedSubjectIds.length}"),
                      trailing: const Icon(Icons.edit_note, color: Colors.blue),
                      onTap: () => _showSubjectSelection(context),
                    ),
                    const Divider(),
                    
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionCtrl, 
                      decoration: InputDecoration(
                        labelText: l10n.tutor_details_description, 
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ), 
                      maxLines: 4
                    ),
                    const Spacer(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, 
                      child: ElevatedButton(
                        onPressed: _onSave, 
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: Text(_existing == null ? l10n.generic_save : l10n.generic_edit)
                      )
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