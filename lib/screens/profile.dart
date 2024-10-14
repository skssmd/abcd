import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onehr/widgets/header_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onehr/widgets/bottom_navigation_bar.dart'; // Import the new bottom navigation bar widget

class StaffDetailScreen extends StatefulWidget {
  @override
  _StaffDetailScreenState createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  Map<String, dynamic>? _staffDetails;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _fetchStaffDetails();
  }

  Future<void> _fetchStaffDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      try {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/staff/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            _staffDetails = jsonDecode(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load staff details. Status: ${response.statusCode}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred while fetching staff details.';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Access token is missing';
        _isLoading = false;
      });
    }
  }
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${_staffDetails!['user']}'),
                      Text('Organization: ${_staffDetails!['organization']}'),
                      Text('Phone: ${_staffDetails!['phone']}'),
                      Text('Address: ${_staffDetails!['address']}'),
                      Text('Leave Balance: ${_staffDetails!['leave_balance']}'),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
      ),
    );
  }
}
