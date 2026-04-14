import '../tutor.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

class TutorRepository {
  final ApiService _api = ApiService();
  final HiveService _cache = HiveService();
  final ConnectivityService _connectivity = ConnectivityService();

  
  Future<List<Tutor>> getAllTutors() async {
    bool isOnline = await _connectivity.isConnected();

    if (isOnline) {
      try {
        final List<dynamic> jsonList = await _api.fetchTutors();
        final List<Tutor> remoteTutors = jsonList.map((e) => Tutor.fromJson(e)).toList();

        await _cache.syncTutors(remoteTutors);
        return remoteTutors;
      } catch (e) {
        
        return await _cache.getTutors();
      }
    } else {
      
      return await _cache.getTutors();
    }
  }

  
  Future<void> addTutor(Tutor tutor) async {
    if (await _connectivity.isConnected()) {
      try {
        final jsonResponse = await _api.createTutor(tutor);
        final savedTutor = Tutor.fromJson(jsonResponse);
        await _cache.putTutor(savedTutor);
      } catch (e) {
        
        rethrow; 
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

  
  Future<void> updateTutor(Tutor tutor) async {
    if (await _connectivity.isConnected()) {
      try {
        await _api.updateTutor(tutor);
        await _cache.putTutor(tutor);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

  
  Future<void> deleteTutor(int serverId) async {
    if (await _connectivity.isConnected()) {
      try {
        await _api.deleteTutor(serverId);
        await _cache.deleteTutor(serverId);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception("error_no_internet");
    }
  }
}