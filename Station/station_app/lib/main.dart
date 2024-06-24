import 'package:flutter/material.dart';
import 'package:station_app/partials/_bottom_navbar.dart';
import 'package:station_app/authentication/login.dart';
import 'package:station_app/authentication/auth_service.dart';

/* 
Colors:
White 0xfff5f7f8;
Yellow 0xfff4ce14;
Blue: 0xff10316B
Gray: 0xff45474b;
Yellow Extra 0xfff2e800;
*/

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use AuthService for authentication
    final authService = AuthService();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Barlow',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfff4ce14),
        ),
      ),
      home: FutureBuilder<String?>(
        // Use FutureBuilder to asynchronously check if the user is logged in
        future: authService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return const CircularProgressIndicator();
          } else {
            // If the Future is complete
            if (snapshot.hasError) {
              // If there's an error, handle it here
              return Text('Error: ${snapshot.error}');
            } else {
              // If there's no error
              final String? accessToken = snapshot.data;

              // Determine if the user is logged in based on the presence of an access token
              bool isLoggedIn = accessToken != null;

              return isLoggedIn
                  ? CustomBottomNavigationBar()
                  : LoginPage(authService: authService);
            }
          }
        },
      ),
    );
  }
}
