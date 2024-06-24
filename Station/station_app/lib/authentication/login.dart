import 'package:station_app/authentication/auth_service.dart';
import 'package:station_app/partials/_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;

  const LoginPage({Key? key, required this.authService}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username Input
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff4ce14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff2e800)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff4ce14)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password Input
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff4ce14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff2e800)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff4ce14)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // Validate input
                  final username = usernameController.text;
                  final password = passwordController.text;

                  if (username.isEmpty || password.isEmpty) {
                    // Handle empty username or password
                    print('Username and password cannot be empty');
                    return;
                  }

                  try {
                    // Call AuthService.login
                    await widget.authService.login(username, password);

                    // Once logged in, navigate to CustomBottomNavigationBar
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomBottomNavigationBar(),
                      ),
                    );
                  } catch (e) {
                    // Handle login error
                    print('Login error: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff10316B), // Background color
                  foregroundColor: Color(0xfffffffff), // Text color
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xfff0f0f0), // Background color
                  foregroundColor: Color(0xff000000), // Text color
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('http://127.0.0.1:8000/accounts/register');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
