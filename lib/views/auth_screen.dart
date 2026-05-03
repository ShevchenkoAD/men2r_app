import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:men2r_app/l10n/app_localizations.dart';
import '../../controllers/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoginMode = true;

void _submit() async {
    final auth = context.read<AuthController>();
    final loginText = _loginCtrl.text.trim();
    final passText = _passCtrl.text.trim();

    if (loginText.isEmpty || passText.isEmpty) return;

    bool success;

    
    if (_isLoginMode) {
      success = await auth.login(loginText, passText);
    } else {
      
      success = await auth.register(loginText, passText);
    }
    
    if (success) {
      if (mounted) Navigator.pushReplacementNamed(context, '/courses');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.auth_error_invalid))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isLoginMode ? l10n.auth_login_title : l10n.auth_register_title,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              controller: _loginCtrl,
              decoration: InputDecoration(labelText: l10n.auth_field_login, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.auth_field_password, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            auth.isLoading 
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                    child: Text(_isLoginMode ? l10n.auth_btn_login : l10n.auth_btn_register),
                  ),
                ),
            TextButton(
              onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
              child: Text(_isLoginMode ? l10n.auth_no_account : l10n.auth_have_account),
            )
          ],
        ),
      ),
    );
  }
}