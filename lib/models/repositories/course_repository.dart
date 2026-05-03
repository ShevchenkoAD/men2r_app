import '../course.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

class CourseRepository {
  final ApiService _api = ApiService();
  final HiveService _cache = HiveService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<List<Course>> getAllCourses({
    int? subjectId,
    double? minPrice,
    double? maxPrice,
    int? minHours,
    int? maxHours,
    String? sortBy,
    String? sortOrder,
  }) async {
    bool isOnline = await _connectivity.isConnected();

    if (isOnline) {
      try {
        
        final List<dynamic> fullJsonList = await _api.fetchCourses();
        final List<Course> allCourses = fullJsonList.map((e) => Course.fromJson(e)).toList();
        await _cache.syncCourses(allCourses);

        
        final List<dynamic> filteredJsonList = await _api.fetchCourses(
          subjectId: subjectId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minHours: minHours,
          maxHours: maxHours,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
        return filteredJsonList.map((e) => Course.fromJson(e)).toList();
      } catch (e) {
        
        return _getOfflineCourses(subjectId, minPrice, maxPrice, minHours, maxHours, sortBy, sortOrder);
      }
    } else {
      
      return _getOfflineCourses(subjectId, minPrice, maxPrice, minHours, maxHours, sortBy, sortOrder);
    }
  }

  /
  Future<List<Course>> _getOfflineCourses(
    int? subjectId,
    double? minPrice,
    double? maxPrice,
    int? minHours,
    int? maxHours,
    String? sortBy,
    String? sortOrder,
  ) async {
    List<Course> all = await _cache.getCourses();

    
    all = all.where((c) {
      bool matchSubject = subjectId == null || c.subjectId == subjectId;
      bool matchPrice = (minPrice == null || c.price >= minPrice) &&
                        (maxPrice == null || c.price <= maxPrice);
      bool matchHours = (minHours == null || c.hours >= minHours) &&
                        (maxHours == null || c.hours <= maxHours);
      return matchSubject && matchPrice && matchHours;
    }).toList();

    
    all.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case 'price':
          cmp = a.price.compareTo(b.price);
          break;
        case 'hours':
          cmp = a.hours.compareTo(b.hours);
          break;
        case 'startDate':
          cmp = a.startDate.compareTo(b.startDate);
          break;
        default:
          cmp = a.title.compareTo(b.title);
      }
      return (sortOrder == 'desc') ? -cmp : cmp;
    });

    return all;
  }

  
  Future<void> addCourse(Course course) async {
    if (await _connectivity.isConnected()) {
      final jsonResponse = await _api.createCourse(course);
      await _cache.putCourse(Course.fromJson(jsonResponse));
    } else {
      throw Exception("error_no_internet");
    }
  }

  Future<void> updateCourse(Course course) async {
    if (await _connectivity.isConnected()) {
      await _api.updateCourse(course);
      await _cache.putCourse(course);
    } else {
      throw Exception("error_no_internet");
    }
  }

  Future<void> deleteCourse(int serverId) async {
    if (await _connectivity.isConnected()) {
      await _api.deleteCourse(serverId);
      await _cache.deleteCourse(serverId);
    } else {
      throw Exception("error_no_internet");
    }
  }
}