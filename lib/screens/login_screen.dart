import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  
  bool _isLoading = false; // Loading state

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // API URL (adjust the base URL to match your Django API)
      const url = 'http://127.0.0.1:8000/api/login/';

      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Send login request
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'username': _username,
            'password': _password,
            'remember_me': true,
          }),
        );

        setState(() {
          _isLoading = false; // Stop loading
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Save JWT tokens and staff ID to local storage (using SharedPreferences)
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('access_token', data['tokens']['access']);
          prefs.setString('refresh_token', data['tokens']['refresh']);
          prefs.setString('staff_id', data['staff_id'].toString()); // Store the staff ID

          // Redirect based on API response
          String redirectUrl = data['redirect_url'];
          if (redirectUrl == '/api/admin_dashboard/') {
            Navigator.pushReplacementNamed(context, '/profile');
          } else if (redirectUrl == '/api/users-home/') {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        } else {
          _showErrorDialog('Invalid credentials, please try again.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('An error occurred. Please check your connection.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) {
                  _username = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
