import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with your actual API URL

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully logged out
      print('Logout successful: ${response.body}');
    } else {
      // Handle error response
      final errorData = jsonDecode(response.body);
      print('Logout failed: ${errorData['error'] ?? 'Unknown error'}');
    }
  }
}
