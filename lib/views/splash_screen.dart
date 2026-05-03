import 'package:flutter/material.dart';
import 'package:men2r_app/controllers/auth_controller.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    
    final auth = context.read<AuthController>();
    await auth.checkAuth(); 

    if (!mounted) return;
    
    if (auth.isAuthenticated) {
      
      Navigator.pushReplacementNamed(context, '/courses');
    } else {
      
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(l10n.app_tittle, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}