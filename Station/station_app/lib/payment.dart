import 'dart:io';

import 'package:flutter/material.dart';
import 'payment_config.dart';
import 'package:pay/pay.dart';
import 'partials/_bottom_navbar.dart';
import 'authentication/auth_service.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> responseData;

  PaymentPage({Key? key, required this.responseData}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late var applePayButton;
  late var googlePayButton;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    var label = widget.responseData["fuel_type"];
    var amount = widget.responseData["fuel_price"];

    applePayButton = ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: [
        PaymentItem(
          label: label,
          amount: amount,
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: 200,
      height: 200,
      type: ApplePayButtonType.buy,
      margin: EdgeInsets.all(15.0),
      onPaymentResult: handlePaymentResult,
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );

    googlePayButton = GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: [
        PaymentItem(
          label: label,
          amount: amount,
          status: PaymentItemStatus.final_price,
        ),
      ],
      width: double.infinity,
      type: GooglePayButtonType.pay,
      margin: EdgeInsets.all(15.0),
      onPaymentResult: handlePaymentResult,
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }

  void handlePaymentResult(Map<String, dynamic> result) {
    try {
      authService.refreshToken();
      authService.processTransaction();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CustomBottomNavigationBar(),
        ),
      );
    } catch (e) {
      print('Error handling payment result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Payment Page')),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Payment In Progress!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'Fuel Type: ${widget.responseData["fuel_type"]}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Amount: ${widget.responseData["fuel_price"]}',
                style: TextStyle(fontSize: 20),
              ),
              Center(child: Platform.isIOS ? applePayButton : googlePayButton),
            ],
          ),
        ),
      ),
    );
  }
}
