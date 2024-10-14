import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onehr/models/leave.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with your actual API URL

  Future<void> requestLeave(Leave leave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token

    final response = await http.post(
      Uri.parse('$baseUrl/leave/request/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(leave.toJson()),
    );

    if (response.statusCode == 201) {
      print('Leave request submitted successfully');
    } else {
      final errorData = jsonDecode(response.body);
      print('Error submitting leave request: ${errorData['error'] ?? 'Unknown error'}');
    }
  }

  Future<List<Leave>> getMyLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token

    final response = await http.get(
      Uri.parse('$baseUrl/leave/my_requests/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((leave) => Leave.fromJson(leave)).toList();
    } else {
      throw Exception('Failed to load leave requests');
    }
  }

  Future<void> editLeaveRequest(int leaveId, Leave leave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token

    final response = await http.put(
      Uri.parse('$baseUrl/leave/edit/$leaveId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(leave.toJson()),
    );

    if (response.statusCode == 200) {
      print('Leave request updated successfully');
    } else {
      final errorData = jsonDecode(response.body);
      print('Error updating leave request: ${errorData['error'] ?? 'Unknown error'}');
    }
  }
}
