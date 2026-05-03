import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:men2r_app/models/services/api_service.dart';

class AuthController extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final ApiService _api = ApiService();

  String? _userName; 
  String? _token;
  String? _role;
  bool _isLoading = false;

  String? get userName => _userName; 
  String? get token => _token;
  String? get role => _role;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<bool> login(String login, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.login(login, password);
      _token = response['token'];
      _role = response['role'];
      _userName = login; 

      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'user_role', value: _role);
      await _storage.write(key: 'user_name', value: _userName); 

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String login, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      
      final response = await _api.register(login, password);
      
      
      _token = response['token'];
      _role = response['role'];
      _userName = login;

      
      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'user_role', value: _role);
      await _storage.write(key: 'user_name', value: _userName);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  
  Future<void> checkAuth() async {
    _token = await _storage.read(key: 'jwt_token');
    _role = await _storage.read(key: 'user_role');
    _userName = await _storage.read(key: 'user_name'); 
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _role = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}