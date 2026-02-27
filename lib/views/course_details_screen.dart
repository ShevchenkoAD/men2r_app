import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart'; 
import '../models/course.dart';
import '../controllers/db_controller.dart';

class DetailsScreen extends StatefulWidget {
  final Course course;
  const DetailsScreen({super.key, required this.course});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
   
  bool _isEditing = false;

   
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
     
    _titleController = TextEditingController(text: widget.course.title);
    _descController = TextEditingController(text: widget.course.description);
    _dateController = TextEditingController(text: widget.course.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbProvider = Provider.of<DbController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editCourse : l10n.courseDetails),  
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                   
                  _titleController.text = widget.course.title;
                  _descController.text = widget.course.description;
                  _dateController.text = widget.course.date;
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEditing) ...[
               
              Text(widget.course.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text("${l10n.date}: ${widget.course.date}", style: const TextStyle(fontStyle: FontStyle.italic)),
              const Divider(height: 30),
              Expanded(child: Text(widget.course.description, style: const TextStyle(fontSize: 18))),
            ] else ...[
               
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.title, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(labelText: l10n.date, border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_today)),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dateController.text = picked.toString().split(' ')[0]);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descController,
                maxLines: 5,
                decoration: InputDecoration(labelText: l10n.description, border: const OutlineInputBorder()),
              ),
              Expanded(child: const SizedBox(height: 20)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {                    
                    final updatedCourse = Course(
                      id: widget.course.id,  
                      title: _titleController.text,
                      description: _descController.text,
                      date: _dateController.text,
                    );
                    dbProvider.updateCourse(updatedCourse);           
                    Navigator.pop(context); 
                  },
                  icon: const Icon(Icons.save),
                  label: Text(l10n.save),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                ),
              ),
            ],
            
             
            if (!_isEditing) ...[
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: 
                ElevatedButton.icon(
                  onPressed: () {                    
                    dbProvider.deleteCourse(widget.course.id!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: Text(l10n.delete),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                ),
              
              ),
            ]
          ],
        ),
      ),
    );
  }
}