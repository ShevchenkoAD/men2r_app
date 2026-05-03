import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/tutor_controller.dart';

class SignalRService {
  late HubConnection _hubConnection;
  final String _hubUrl = "http://yatxo-178-121-75-105.run.pinggy-free.link/api/updates"; 

  
  Future<void> initSignalR(BuildContext context) async {
    final storage = const FlutterSecureStorage();
    Logger.root.level = Level.ALL;
    
    _hubConnection = HubConnectionBuilder()
        .withUrl(_hubUrl, options: HttpConnectionOptions(
          
          accessTokenFactory: () async {
            final token = await storage.read(key: 'jwt_token');
            return token ?? ""; 
          },
        ))
        .withAutomaticReconnect()
        .build();

    
    _hubConnection.on("ReceiveMessage", (arguments) {
      print("SignalR RAW DATA: $arguments"); 
      
      if (arguments != null && arguments.isNotEmpty) {
        final String message = arguments[0] as String;
        if (message == "REFRESH_DATA") {
          _refreshData(context);
        }
      }
    });

    
    try {
      await _hubConnection.start();
      print("SignalR: Соединение установлено");
    } catch (e) {
      print("SignalR Error: $e");
    }
  }

  void _refreshData(BuildContext context) {
    
    context.read<CourseController>().fetchCourses();
    context.read<TutorController>().fetchTutors();
  }

  
  void stopConnection() {
    _hubConnection.stop();
  }
}