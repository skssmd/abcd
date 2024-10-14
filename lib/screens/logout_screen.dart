import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For token storage

class LogoutScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Assuming you store the token in SharedPreferences

    if (token != null) {
      await _authService.logout(token);

      // Clear token after logout
      await prefs.remove('token');

      // Navigate to login screen or home screen after logout
      Navigator.pushReplacementNamed(context, '/login'); // Adjust according to your routing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
