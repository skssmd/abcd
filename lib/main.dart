import 'package:flutter/material.dart';
import 'package:onehr/screens/my_documents_screen.dart';
import 'package:onehr/screens/edit_document_screen.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/profile.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_update_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/password_change_screen.dart';
import 'screens/register_screen.dart'; 
import 'screens/logout_screen.dart';
import 'screens/request_leave_screen.dart';
import 'screens/my_leave_requests_screen.dart';
import 'screens/edit_leave_request_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Django Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        // Authentication and User Management Routes
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/logout': (context) => LogoutScreen(),
        '/profile': (context) => StaffDetailScreen(),
        '/update_profile': (context) => ProfileUpdateScreen(),
        '/password_reset': (context) => PasswordResetScreen(),
        '/change_password': (context) => PasswordChangeScreen(),

        // Notification and Leave Management Routes
        '/notifications': (context) => NotificationsScreen(),
        '/request-leave': (context) => RequestLeaveScreen(),
        '/my-leave-requests': (context) => MyLeaveRequestsScreen(),

        // Document Management Routes
        '/my_documents': (context) => MyDocumentsPage(),
        '/edit_document': (context) => EditDocumentScreen(),
        
        // Leave Request Editing Route with Arguments Handling
        '/edit-leave-request': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey('leaveId') || !args.containsKey('token')) {
            // Handle the case when arguments are missing
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(child: Text('Invalid arguments for editing leave request')),
            );
          }
          final leaveId = args['leaveId'];
          final token = args['token'];
          return EditLeaveRequestScreen(leaveId: leaveId, token: token);
        },

        // Admin Dashboard Route (Uncomment if needed)
        // '/admin_dashboard': (context) => AdminDashboard(),
      },
    );
  }
}