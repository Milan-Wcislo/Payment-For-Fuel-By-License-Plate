import 'dart:async';
import 'package:flutter/material.dart';
import 'package:station_app/authentication/auth_service.dart';
import 'package:station_app/authentication/login.dart';
import 'package:station_app/coupons.dart';
import 'package:station_app/payment.dart';
import 'package:station_app/payments.dart';
import 'package:station_app/products.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<Widget> _pages = [
    const Products(),
    CouponsPage(),
    const PaymentsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      try {
        Map<String, dynamic> result = await AuthService().getTransaction();
        if (result['shouldStopTimer']) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PaymentPage(responseData: result['data'])),
          );
        }
      } catch (e) {
        print('Error fetching transaction data: $e');
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff10316B),
        title: const Text(
          'STATION',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 24.0,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.yellow,
          size: 32.0,
        ),
        actions: [
          const Icon(
            Icons.bolt, // Replace with the bolt icon
            color: Color(0xfff4ce14),
            size: 32.0,
          ),
          FutureBuilder(
            future: AuthService().getLoyaltyProgram(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final loyaltyPoints = snapshot.data?['loyalty_points'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      '$loyaltyPoints',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Logout to receive points',
                    style: const TextStyle(
                      color: Colors.yellow,
                    ),
                  );
                }
              }
              return Container();
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              showUserOptions(context);
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 34.0),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, size: 34.0),
            label: "Coupons",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card, size: 34.0),
            label: "Payments",
          ),
        ],
        unselectedItemColor: const Color(0xfff4ce14),
        selectedItemColor: const Color(0xfff2e800),
        backgroundColor: Color(0xff10316B),
        showUnselectedLabels: false, // Hides labels for unselected items
        showSelectedLabels: false, //
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void showUserOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Logout'),
              onTap: () {
                AuthService().logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(authService: AuthService()),
                  ),
                  (route) => false,
                );
              },
            ),
            ListTile(
              title: Text('User Settings'),
              onTap: () {
                AuthService().logout();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
