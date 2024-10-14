import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _errorMessage;

  Future<void> _sendPasswordResetLink() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/password/reset/'), // Replace with your actual API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset link sent if email exists!')));
      Navigator.pop(context); // Go back after sending the reset link
    } else {
      final errorData = jsonDecode(response.body);
      setState(() {
        _errorMessage = errorData['email']?.toString() ?? 'Failed to send reset link';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value,
                validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _sendPasswordResetLink();
                  }
                },
                child: Text('Send Password Reset Link'),
              ),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
