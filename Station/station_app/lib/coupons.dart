import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:station_app/authentication/auth_service.dart';

class BarcodeDialog extends StatelessWidget {
  static const String baseUrl = 'http://10.0.2.2:8000';
  final String codeImageUrl;

  BarcodeDialog({required this.codeImageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: 90 * 3.14159265359 / 180, // Rotate 90 degrees in radians
              child: Image.network(
                '$baseUrl/$codeImageUrl',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff10316B), // Background color
                onPrimary: Color(0xfffffffff), // Text color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponsPage extends StatefulWidget {
  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  static const String baseUrl = 'http://10.0.2.2:8000';
  final AuthService authService = AuthService();
  List<Map<String, dynamic>> userCoupons = [];

  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      final List<Map<String, dynamic>> coupons =
          await authService.getCouponsProgram();
      setState(() {
        userCoupons = coupons;
      });
    } catch (e) {
      // Handle error
      print('Error fetching user coupons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your Coupons')),
      ),
      body: Center(
        child: userCoupons.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'No coupons found',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: userCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = userCoupons[index];
                  return Center(
                    child: Card(
                      margin: EdgeInsets.all(16.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        leading: Image.network(
                          '$baseUrl/${coupon['product_image']}',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        title: Center(
                          child: Text(coupon['name']),
                        ),
                        subtitle: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(0xff10316B), // Background color
                                  foregroundColor:
                                      Color(0xfffffffff), // Text color
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: BarcodeDialog(
                                            codeImageUrl: coupon['code_image']),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Show Code',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Customize the ListTile based on your Coupon model
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
