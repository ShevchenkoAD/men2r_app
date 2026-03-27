import 'package:hive_flutter/hive_flutter.dart';
import '../tutor.dart';
import '../course.dart';

class HiveService {
  static const String tutorBoxName = 'tutors_box';
  static const String courseBoxName = 'courses_box';

  
  Future<void> init() async {
    await Hive.initFlutter();
    
    
    Hive.registerAdapter(TutorAdapter());
    Hive.registerAdapter(CourseAdapter());

    
    await Hive.openBox<Tutor>(tutorBoxName);
    await Hive.openBox<Course>(courseBoxName);
  }

  
  
  Box<Tutor> get _tutorBox => Hive.box<Tutor>(tutorBoxName);

  Future<List<Tutor>> getTutors() async => _tutorBox.values.toList();

  Future<void> syncTutors(List<Tutor> tutors) async {
    await _tutorBox.clear();
    
    Map<int, Tutor> map = {for (var t in tutors) t.serverId: t};
    await _tutorBox.putAll(map);
  }

  Future<void> putTutor(Tutor tutor) async {
    await _tutorBox.put(tutor.serverId, tutor);
  }

  Future<void> deleteTutor(int serverId) async {
    await _tutorBox.delete(serverId);
  }

  

  Box<Course> get _courseBox => Hive.box<Course>(courseBoxName);

  Future<List<Course>> getCourses() async => _courseBox.values.toList();

  Future<void> syncCourses(List<Course> courses) async {
    await _courseBox.clear();
    Map<int, Course> map = {for (var c in courses) c.serverId: c};
    await _courseBox.putAll(map);
  }

  Future<void> putCourse(Course course) async {
    await _courseBox.put(course.serverId, course);
  }

  Future<void> deleteCourse(int serverId) async {
    await _courseBox.delete(serverId);
  }
}