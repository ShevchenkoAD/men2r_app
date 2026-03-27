import 'package:flutter/material.dart';
import '../models/tutor.dart';
import '../models/repositories/tutor_repository.dart';

class TutorController extends ChangeNotifier {
  final TutorRepository _repository = TutorRepository();

  List<Tutor> _tutors = [];
  List<Tutor> get tutors => _tutors;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorKey;
  String? get errorKey => _errorKey;

  
  void clearError() {
    _errorKey = null;
    notifyListeners();
  }

  
  Future<void> fetchTutors() async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      _tutors = await _repository.getAllTutors();
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> addTutor(Tutor tutor) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.addTutor(tutor);
      await fetchTutors(); 
      return true;
    } catch (e) {
      _errorKey = _parseError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<void> deleteTutor(int serverId) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.deleteTutor(serverId);
      _tutors.removeWhere((t) => t.serverId == serverId);
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<bool> updateTutor(Tutor tutor) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.updateTutor(tutor);
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

  
  String _parseError(Object e) {
    final errStr = e.toString();
    
    return errStr.replaceAll("Exception: ", "");
  }
}