import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/repositories/course_repository.dart';

class CourseController extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorKey;
  String? get errorKey => _errorKey;

  void clearError() {
    _errorKey = null;
    notifyListeners();
  }

  
  Future<void> fetchCourses() async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      _courses = await _repository.getAllCourses();
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> createCourse(Course course) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.addCourse(course);
      await fetchCourses();
      return true;
    } catch (e) {
      _errorKey = _parseError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> updateCourse(Course course) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.updateCourse(course);
      await fetchCourses();
      return true;
    } catch (e) {
      _errorKey = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> deleteCourse(int serverId) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      await _repository.deleteCourse(serverId);
      _courses.removeWhere((c) => c.serverId == serverId);
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  String _parseError(Object e) {
    return e.toString().replaceAll("Exception: ", "");
  }
}