import 'package:dio/dio.dart';
import '../tutor.dart';
import '../course.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://qlipx-37-45-209-54.a.free.pinggy.link/api/v1.0',
    connectTimeout: const Duration(seconds: 5),
  ));

  

  Future<List<dynamic>> fetchTutors() async {
    final response = await _dio.get('/tutors');
    return response.data as List;
  }

  Future<Map<String, dynamic>> createTutor(Tutor tutor) async {
    
    final response = await _dio.post('/tutors', data: {
      "lastname": tutor.lastname,
      "firstname": tutor.firstname,
      "patronymic": tutor.patronymic,
      "experience": tutor.experience,
      "description": tutor.description,
      "subjects": tutor.subjects,
    });
    return response.data;
  }

  Future<void> updateTutor(Tutor tutor) async {
    await _dio.put('/tutors', data: {
      "id": tutor.serverId, 
      "lastname": tutor.lastname,
      "firstname": tutor.firstname,
      "patronymic": tutor.patronymic,
      "experience": tutor.experience,
      "description": tutor.description,
      "subjects": tutor.subjects,
    });
  }

  Future<void> deleteTutor(int serverId) async {
    await _dio.delete('/tutors/$serverId');
  }

  

  Future<List<dynamic>> fetchCourses() async {
    final response = await _dio.get('/courses');
    return response.data as List;
  }

  Future<Map<String, dynamic>> createCourse(Course course) async {
    final response = await _dio.post('/courses', data: {
      "title": course.title,
      "description": course.description,
      "startDate": course.startDate,
      "endDate": course.endDate,
      "tutorId": course.tutorId,
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
      "hours": course.hours,
      "price": course.price,
    });
  }

  Future<void> deleteCourse(int serverId) async {
    await _dio.delete('/courses/$serverId');
  }
} 