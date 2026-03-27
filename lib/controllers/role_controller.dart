import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AppUserRole { admin, student }

class RoleController extends ChangeNotifier {
  AppUserRole _role = AppUserRole.student; 
  AppUserRole get role => _role;

  RoleController() {
    _loadRole(); 
  }

  
  Future<void> setRole(AppUserRole role) async {
    _role = role;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString("userRole", role.name);
  }

  
  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final String? roleName = prefs.getString("userRole");

    if (roleName != null) {
      if (roleName == AppUserRole.admin.name) {
        _role = AppUserRole.admin;
      } else {
        _role = AppUserRole.student;
      }
      notifyListeners();
    }
  }

  
  bool get isAdmin => _role == AppUserRole.admin;
}