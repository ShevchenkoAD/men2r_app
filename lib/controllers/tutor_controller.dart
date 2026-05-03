import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import '../models/tutor.dart';
import '../models/repositories/tutor_repository.dart';

class TutorController extends ChangeNotifier {
  final TutorRepository _repository = TutorRepository();

  List<Tutor> _allTutors = [];
  List<Tutor> _displayList = [];
  
  List<Tutor> get tutors => _displayList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorKey;
  String? get errorKey => _errorKey;

  
  int get maxExperienceInDb => _allTutors.isEmpty 
      ? 50 
      : _allTutors.map((t) => t.experience).reduce(max);

  
  void runSearch(String query) {
    if (query.isEmpty) {
      _displayList = _allTutors;
    } else {
      final fuse = Fuzzy<Tutor>(
        _allTutors,
        options: FuzzyOptions(
          keys: [
            WeightedKey(name: 'lastname', getter: (t) => t.lastname, weight: 1.0),
            WeightedKey(name: 'firstname', getter: (t) => t.firstname, weight: 1.0),
          ],
          threshold: 0.5,
        ),
      );
      final results = fuse.search(query);
      _displayList = results.map((r) => r.item).toList();
    }
    notifyListeners();
  }

  
  Future<void> fetchTutors({
    int? subjectId, 
    String? sortBy, 
    String? sortOrder
  }) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      _allTutors = await _repository.getAllTutors(
        subjectId: subjectId, 
        sortBy: sortBy, 
        sortOrder: sortOrder
      );
      _displayList = _allTutors;
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> addTutor(Tutor tutor, List<int> subjectIds, File? imageFile) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.addTutor(tutor, subjectIds, imageFile);
      await fetchTutors(); return true;
    } catch (e) { _errorKey = _parseError(e); return false;
    } finally { _isLoading = false; notifyListeners(); }
  }


  Future<bool> updateTutor(Tutor tutor, List<int> subjectIds, File? imageFile) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      
      await _repository.updateTutor(tutor, subjectIds, imageFile);
      await fetchTutors(); 
      return true;
    } catch (e) {
      _errorKey = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTutor(int serverId) async {
    try {
      await _repository.deleteTutor(serverId);
      _allTutors.removeWhere((t) => t.serverId == serverId);
      _displayList.removeWhere((t) => t.serverId == serverId);
      notifyListeners();
    } catch (e) { _errorKey = _parseError(e); notifyListeners(); }
  }

  String _parseError(Object e) => e.toString().replaceAll("Exception: ", "");
}