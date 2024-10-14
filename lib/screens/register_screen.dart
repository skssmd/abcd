import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName, _username, _email, _password1, _password2;
  String? _errorMessage;

  Future<void> _registerUser() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/register/'), // Replace with your actual API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': _firstName,
        'last_name': _lastName,
        'username': _username,
        'email': _email,
        'password1': _password1,
        'password2': _password2,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful! Verification email sent.')));
      Navigator.pop(context); // Go back to the previous screen (or home screen)
    } else {
      // Handle error response
      final errorData = jsonDecode(response.body);
      setState(() {
        _errorMessage = errorData['error'] ?? 'Registration failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _firstName = value,
                validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _lastName = value,
                validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) => _username = value,
                validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value,
                validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password1 = value,
                validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (value) => _password2 = value,
                validator: (value) => value == null || value.isEmpty ? 'Please confirm your password' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _registerUser();
                  }
                },
                child: Text('Register'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
