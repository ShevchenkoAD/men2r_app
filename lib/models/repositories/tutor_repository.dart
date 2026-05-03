import 'dart:io';
import '../tutor.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';

class TutorRepository {
  final ApiService _api = ApiService();
  final HiveService _cache = HiveService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<List<Tutor>> getAllTutors({int? subjectId, String? sortBy, String? sortOrder}) async {
    bool isOnline = await _connectivity.isConnected();

    if (isOnline) {
      try {
        
        final fullJson = await _api.fetchTutors();
        final List<Tutor> allTutors = fullJson.map((e) => Tutor.fromJson(e)).toList();
        await _cache.syncTutors(allTutors);

        
        final filteredJson = await _api.fetchTutors(
          subjectId: subjectId, 
          sortBy: sortBy, 
          sortOrder: sortOrder
        );
        return filteredJson.map((e) => Tutor.fromJson(e)).toList();
      } catch (e) {
        return _getOfflineTutors(subjectId, sortBy, sortOrder);
      }
    } else {
      
      return _getOfflineTutors(subjectId, sortBy, sortOrder);
    }
  }

  /
  Future<List<Tutor>> _getOfflineTutors(int? subjectId, String? sortBy, String? sortOrder) async {
    List<Tutor> all = await _cache.getTutors();

    
    if (subjectId != null) {
      all = all.where((t) => t.subjects?.any((s) => s.id == subjectId) ?? false).toList();
    }

    
    all.sort((a, b) {
      int cmp;
      if (sortBy == 'experience') {
        cmp = a.experience.compareTo(b.experience);
      } else {
        
        cmp = a.lastname.compareTo(b.lastname);
      }
      return (sortOrder == 'desc') ? -cmp : cmp;
    });

    return all;
  }

  Future<void> addTutor(Tutor tutor, List<int> subjectIds, File? imageFile) async {
    if (await _connectivity.isConnected()) {
      final jsonResponse = await _api.createTutor(tutor, subjectIds);
      final int serverId = jsonResponse['id'];

      if (imageFile != null) {
        final updatedJson = await _api.uploadTutorPhoto(serverId, imageFile);
        await _cache.putTutor(Tutor.fromJson(updatedJson));
      } else {
        await _cache.putTutor(Tutor.fromJson(jsonResponse));
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

Future<void> updateTutor(Tutor tutor, List<int> subjectIds, File? imageFile) async {
    if (await _connectivity.isConnected()) {
      
      await _api.updateTutor(tutor, subjectIds);

      
      if (imageFile != null) {
        final updatedJson = await _api.uploadTutorPhoto(tutor.serverId, imageFile);
        
        await _cache.putTutor(Tutor.fromJson(updatedJson));
      } else {
        
        await _cache.putTutor(tutor);
      }
    } else {
      throw Exception("error_no_internet");
    }
  }

  Future<void> deleteTutor(int serverId) async {
    if (await _connectivity.isConnected()) {
      await _api.deleteTutor(serverId);
      await _cache.deleteTutor(serverId);
    } else {
      throw Exception("error_no_internet");
    }
  }
}