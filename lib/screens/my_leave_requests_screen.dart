import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onehr/widgets/bottom_navigation_bar.dart';
import 'package:onehr/widgets/header_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class MyLeaveRequestsScreen extends StatefulWidget {
  @override
  _MyLeaveRequestsScreenState createState() => _MyLeaveRequestsScreenState();
}

class _MyLeaveRequestsScreenState extends State<MyLeaveRequestsScreen> {
  List<dynamic> _leaveRequests = [];

  Future<void> _fetchLeaveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = Uri.parse('http://127.0.0.1:8000/api/my-leave-requests/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _leaveRequests = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch leave requests: ${response.body}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }
  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
      body: ListView.builder(
        itemCount: _leaveRequests.length,
        itemBuilder: (context, index) {
          final leave = _leaveRequests[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text('Leave from ${leave['start_date']} to ${leave['end_date']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reason: ${leave['reason']}'),
                  Text('Status: ${leave['status']}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-leave-request',
                    arguments: {
                      'leaveId': leave['id'],
                      'token': 'bearer ',
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/request-leave');
        },
        child: Icon(Icons.add),
        tooltip: 'Request Leave',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      
      bottomNavigationBar: BottomNavigationBarWidget(
         currentIndex: _currentIndex,
      ),
    );
  }
}
