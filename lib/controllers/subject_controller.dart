import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/repositories/subject_repository.dart';

class SubjectController extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await _repository.getAllSubjects();
    } catch (e) {
      print("Ошибка загрузки предметов: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}