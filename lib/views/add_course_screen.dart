import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../controllers/db_controller.dart';
import '../models/course.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addCourse)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: l10n.title)),
            TextField(controller: _descController, decoration: InputDecoration(labelText: l10n.description)),
            TextField(
              controller: _dateController, 
              decoration: InputDecoration(labelText: l10n.date),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(2000), lastDate: DateTime(2101));
                if (pickedDate != null) {
                  setState(() => _dateController.text = pickedDate.toString().split(' ')[0]);
                }
              },
0            ),
            Expanded(child: const SizedBox(height: 20)),
            SizedBox(
              width: double.infinity,
              child: 
              ElevatedButton.icon(
                  onPressed: () {                    
                    if (_titleController.text.isNotEmpty && _dateController.text.isNotEmpty) {
                      Provider.of<DbController>(context, listen: false).addCourse(
                        Course(
                          title: _titleController.text,
                          description: _descController.text,
                          date: _dateController.text,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(l10n.error),
                                content: Text(l10n.courseInvalidErrorMessage),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                    };
                  },
                  icon: const Icon(Icons.save),
                  label: Text(l10n.save),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                ),
            )
          ],
        ),
      ),
    );
  }
}