import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HeaderBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HeaderBarState createState() => _HeaderBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HeaderBarState extends State<HeaderBar> {
  int unreadNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = 'http://127.0.0.1:8000/api/notifications/'; // Replace with your actual API URL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        unreadNotificationCount = data['unread_notifications_count'];
      });
    } else {
      // Handle the error case
      print('Failed to fetch notifications');
    }
  }

  void _onNotificationTap() {
    Navigator.pushNamed(context, '/notifications'); // Navigate to notifications screen
  }

  void _onNavbarTogglerTap() {
    Scaffold.of(context).openDrawer(); // Open the navigation drawer
  }

  void _onMenuItemSelected(String value) {
    switch (value) {
      case 'update_profile':
        Navigator.pushNamed(context, '/update_profile');
        break;
      case 'change_password':
        Navigator.pushNamed(context, '/change_password');
        break;
      case 'logout':
        Navigator.pushNamed(context, '/logout');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('OneHr'),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications),
              if (unreadNotificationCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$unreadNotificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: _onNotificationTap,
        ),
        PopupMenuButton<String>(
          onSelected: _onMenuItemSelected,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'update_profile',
                child: Text('Update Profile'),
              ),
              PopupMenuItem<String>(
                value: 'change_password',
                child: Text('Change Password'),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ];
          },
          icon: Icon(Icons.menu), // Menu icon
        ),
      ],
    );
  }
}
