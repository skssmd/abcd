// lib/screens/notifications_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  int _unreadNotificationsCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      try {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/notifications/'), // Replace with your actual API URL
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _notifications = data['all_notifications'];
            _unreadNotificationsCount = data['unread_notifications_count'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch notifications. Status: ${response.statusCode}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred while fetching notifications.';
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

  Future<void> _markNotificationAsRead(int notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/notifications/$notificationId/read/'), // Replace with your actual API URL
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final redirectUrl = data['redirect_url'];

          // Refresh the notifications list
          _fetchNotifications();

          // If the notification has a redirect link, navigate to it
          if (redirectUrl != null) {
            Navigator.pushNamed(context, redirectUrl);
          }
        } else {
          print('Failed to mark notification as read. Status: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred while marking the notification as read.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications ($_unreadNotificationsCount unread)'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      title: Text(notification['message']),
                      subtitle: Text(notification['created_at']),
                      trailing: notification['is_read']
                          ? null
                          : Icon(Icons.circle, color: Colors.red, size: 10),
                      onTap: () {
                        // Mark as read when tapped
                        _markNotificationAsRead(notification['id']);
                      },
                    );
                  },
                ),
    );
  }
}
