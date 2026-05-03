import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import '../models/course.dart';
import '../models/repositories/course_repository.dart';

class CourseController extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  List<Course> _allCourses = []; 
  List<Course> _displayList = []; 
  
  List<Course> get courses => _displayList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorKey;
  String? get errorKey => _errorKey;

  
  
  double get maxPriceInDb => _allCourses.isEmpty 
      ? 1000.0 
      : _allCourses.map((c) => c.price).reduce(max).toDouble();

  int get maxHoursInDb => _allCourses.isEmpty 
      ? 100 
      : _allCourses.map((c) => c.hours).reduce(max);

  
  void runSearch(String query) {
    if (query.isEmpty) {
      _displayList = _allCourses;
    } else {
      final fuse = Fuzzy<Course>(
        _allCourses,
        options: FuzzyOptions(
          keys: [
            WeightedKey(name: 'title', getter: (c) => c.title, weight: 1.0),
            WeightedKey(name: 'description', getter: (c) => c.description, weight: 0.5),
          ],
          threshold: 0.5, 
        ),
      );
      final results = fuse.search(query);
      _displayList = results.map((r) => r.item).toList();
    }
    notifyListeners();
  }

  
  Future<void> fetchCourses({
    int? subjectId,
    double? minPrice,
    double? maxPrice,
    int? minHours,
    int? maxHours,
    String? sortBy, 
    String? sortOrder,
  }) async {
    _isLoading = true;
    _errorKey = null;
    notifyListeners();

    try {
      _allCourses = await _repository.getAllCourses(
        subjectId: subjectId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minHours: minHours,
        maxHours: maxHours,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      _displayList = _allCourses;
    } catch (e) {
      _errorKey = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> createCourse(Course course) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.addCourse(course);
      await fetchCourses(); return true;
    } catch (e) { _errorKey = _parseError(e); return false;
    } finally { _isLoading = false; notifyListeners(); }
  }

  Future<bool> updateCourse(Course course) async {
    _isLoading = true; notifyListeners();
    try {
      await _repository.updateCourse(course);
      await fetchCourses(); return true;
    } catch (e) { _errorKey = _parseError(e); return false;
    } finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> deleteCourse(int serverId) async {
    try {
      await _repository.deleteCourse(serverId);
      _allCourses.removeWhere((c) => c.serverId == serverId);
      _displayList.removeWhere((c) => c.serverId == serverId);
      notifyListeners();
    } catch (e) { _errorKey = _parseError(e); notifyListeners(); }
  }

  String _parseError(Object e) => e.toString().replaceAll("Exception: ", "");
}