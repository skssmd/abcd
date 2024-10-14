import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditLeaveRequestScreen extends StatefulWidget {
  final int leaveId;
  final String token;

  EditLeaveRequestScreen({required this.leaveId, required this.token});

  @override
  _EditLeaveRequestScreenState createState() => _EditLeaveRequestScreenState();
}

class _EditLeaveRequestScreenState extends State<EditLeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _updateLeaveRequest() async {
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final reason = _reasonController.text;
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = Uri.parse('http://127.0.0.1:8000/api/edit-leave-request/${widget.leaveId}/');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'start_date': startDate,
        'end_date': endDate,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave request updated successfully.')),
      );
      Navigator.pop(context); // Go back to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update leave request: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Leave Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason for Leave'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a reason for the leave';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateLeaveRequest();
                  }
                },
                child: Text('Update Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
