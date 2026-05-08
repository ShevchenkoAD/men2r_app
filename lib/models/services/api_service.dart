import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:men2r_app/main.dart';
import 'package:men2r_app/models/tutor.dart';
import 'package:men2r_app/models/course.dart';
import 'package:men2r_app/models/subject.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();
  
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: "http://vhibt-178-121-67-24.run.pinggy-free.link/api/v1.0",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          
          const storage = FlutterSecureStorage();
          await storage.deleteAll();
          
          
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/auth', (route) => false);
        }
        return handler.next(e);
      },
    ));
  }

  

  Future<Map<String, dynamic>> login(String login, String password) async {
    final response = await _dio.post('/auth/login', data: {
      "login": login,
      "password": password,
    });
    return response.data; 
  }

  Future<Map<String, dynamic>> register(String login, String password) async {
    final response = await _dio.post('/auth/register', data: {
      "login": login,
      "password": password,
    });
    return response.data;
  }

  

  Future<List<dynamic>> fetchSubjects() async {
    final response = await _dio.get('/subjects');
    return response.data as List;
  }

  

  Future<List<dynamic>> fetchTutors({int? subjectId, String? sortBy, String? sortOrder}) async {
    final response = await _dio.get('/tutors', queryParameters: {
      if (subjectId != null) 'subjectId': subjectId,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
    });
    return response.data as List;
  }

  Future<Map<String, dynamic>> createTutor(Tutor tutor, List<int> subjectIds) async {
    final response = await _dio.post('/tutors', data: {
      "lastname": tutor.lastname,
      "firstname": tutor.firstname,
      "patronymic": tutor.patronymic,
      "experience": tutor.experience,
      "description": tutor.description,
      "subjectIds": subjectIds, 
    });
    return response.data;
  }

  Future<Map<String, dynamic>> uploadTutorPhoto(int serverId, File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final response = await _dio.post('/tutors/$serverId/photo', data: formData);
    return response.data;
  }

  Future<void> updateTutor(Tutor tutor, List<int> subjectIds) async {
    await _dio.put('/tutors', data: {
      "id": tutor.serverId,
      "lastname": tutor.lastname,
      "firstname": tutor.firstname,
      "patronymic": tutor.patronymic,
      "experience": tutor.experience,
      "description": tutor.description,
      "subjectIds": subjectIds,
    });
  }

  Future<void> deleteTutor(int serverId) async {
    await _dio.delete('/tutors/$serverId');
  }

  

  Future<List<dynamic>> fetchCourses({
    int? subjectId,
    double? minPrice,
    double? maxPrice,
    int? minHours,
    int? maxHours,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await _dio.get('/courses', queryParameters: {
      if (subjectId != null) 'subjectId': subjectId,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (minHours != null) 'minHours': minHours,
      if (maxHours != null) 'maxHours': maxHours,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
    });
    return response.data as List;
  }

  Future<Map<String, dynamic>> createCourse(Course course) async {
    final response = await _dio.post('/courses', data: {
      "title": course.title,
      "description": course.description,
      "startDate": course.startDate,
      "endDate": course.endDate,
      "tutorId": course.tutorId,
      "subjectId": course.subjectId, 
      "hours": course.hours,
      "price": course.price,
    });
    return response.data;
  }

  Future<void> updateCourse(Course course) async {
    await _dio.put('/courses', data: {
      "id": course.serverId,
      "title": course.title,
      "description": course.description,
      "startDate": course.startDate,
      "endDate": course.endDate,
      "tutorId": course.tutorId,
      "subjectId": course.subjectId,
      "hours": course.hours,
      "price": course.price,
    });
  }

  Future<void> deleteCourse(int serverId) async {
    await _dio.delete('/courses/$serverId');
  }
}