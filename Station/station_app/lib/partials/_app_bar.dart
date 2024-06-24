import 'package:flutter/material.dart';
import 'package:station_app/authentication/login.dart';
import 'package:station_app/authentication/auth_service.dart';
// import 'package:station_app/';

class UserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'settings') {
          // Handle settings route navigation
          //  Navigator.push(
          // context,
          // MaterialPageRoute(
          // builder: (context) => LoginPage(authService: authService)));
        } else if (value == 'logout') {
          await authService.logout();

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(authService: authService)));
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ),
      ],
      icon: const CircleAvatar(
        // Display your user avatar here
        backgroundColor: Colors.white,
        // Display your user avatar here
        child: Icon(Icons.person_rounded),
      ),
    );
  }
}
