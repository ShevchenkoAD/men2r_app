import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';

class DbController extends ChangeNotifier {
  Database? _database;
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'education.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE courses(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT)',
        );
      },
      version: 1,
    );
    await fetchCourses();
  }

  Future<void> fetchCourses() async {
    final List<Map<String, dynamic>> maps = await _database!.query('courses');
    _courses = List.generate(maps.length, (i) => Course.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> updateCourse(Course course) async {
    if (_database == null) return;
    
    await _database!.update(
      'courses',
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
    await fetchCourses(); 
  }

  Future<void> addCourse(Course course) async {
    await _database!.insert('courses', course.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchCourses();
  }

  Future<void> deleteCourse(int id) async {
    await _database!.delete('courses', where: 'id = ?', whereArgs: [id]);
    await fetchCourses();
  }
}