import '../course.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

class CourseRepository {
  final ApiService _api = ApiService();
  final HiveService _cache = HiveService(); 
  final ConnectivityService _connectivity = ConnectivityService();

  Future<List<Course>> getAllCourses() async {
    bool isOnline = await _connectivity.isConnected();

    if (isOnline) {
      try {
        final List<dynamic> jsonList = await _api.fetchCourses();
        final List<Course> remoteCourses = jsonList.map((e) => Course.fromJson(e)).toList();
        await _cache.syncCourses(remoteCourses);
        return remoteCourses;
      } catch (e) {
        return await _cache.getCourses();
      }
    } else {
      return await _cache.getCourses();
    }
  }

  Future<void> addCourse(Course course) async {
    if (await _connectivity.isConnected()) {
      try {
        final jsonResponse = await _api.createCourse(course);
        final savedCourse = Course.fromJson(jsonResponse);
        await _cache.putCourse(savedCourse);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

  Future<void> updateCourse(Course course) async {
    if (await _connectivity.isConnected()) {
      try {
        await _api.updateCourse(course);
        await _cache.putCourse(course);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

  Future<void> deleteCourse(int serverId) async {
    if (await _connectivity.isConnected()) {
      try {
        await _api.deleteCourse(serverId);
        await _cache.deleteCourse(serverId);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception("error_no_internet");
    }
  }
}