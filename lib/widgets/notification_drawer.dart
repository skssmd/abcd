import 'package:flutter/material.dart';

class NotificationDrawer extends StatelessWidget {
  final List<String> notifications;
  final int unreadCount;

  const NotificationDrawer({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Text('Notifications ($unreadCount)'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                  onTap: () {
                    // Handle notification tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
