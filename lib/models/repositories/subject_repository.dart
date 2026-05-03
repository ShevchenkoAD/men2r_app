import '../subject.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

class SubjectRepository {
  final ApiService _api = ApiService();
  final HiveService _cache = HiveService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<List<Subject>> getAllSubjects() async {
    if (await _connectivity.isConnected()) {
      try {
        final List<dynamic> jsonList = await _api.fetchSubjects();
        final List<Subject> subjects = jsonList.map((e) => Subject.fromJson(e)).toList();
        await _cache.syncSubjects(subjects);
        return subjects;
      } catch (e) {
        return await _cache.getSubjects();
      }
    } else {
      return await _cache.getSubjects();
    }
  }
}