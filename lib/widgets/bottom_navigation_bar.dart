import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushNamed(context, '/my-leave-requests');
        break;
      case 3:
        Navigator.pushNamed(context, '/my_documents');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTabTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.time_to_leave),
          label: 'Leave',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'Documents',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
