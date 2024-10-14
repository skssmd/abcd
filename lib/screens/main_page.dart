import 'package:flutter/material.dart';
import 'package:onehr/widgets/header_bar.dart';
 // Import your HeaderBar file here

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: HomeScreen(), // Replace with your home screen
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(), // Use your custom HeaderBar here
      body: Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}