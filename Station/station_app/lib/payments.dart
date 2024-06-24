import 'package:flutter/material.dart';
import 'dart:convert';

import 'authentication/auth_service.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  List<Map<String, dynamic>> userTransactions = [];
  final AuthService authService = AuthService();
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      final List<Map<String, dynamic>> transactions =
          await authService.getPaymentsProgram();
      setState(() {
        userTransactions = transactions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Failed to fetch payments: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Payments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : userTransactions.isEmpty
                  ? Center(child: Text('No transactions found'))
                  : ListView.builder(
                      itemCount: userTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = userTransactions[index];

                        final fuel_price = transaction['fuel_price'];
                        final fuel_amount = transaction['fuel_amount'];
                        final fuel_type = transaction['fuel_type'];
                        final date = transaction['timestamp'];

                        return ListTile(
                          title: Text(fuel_type),
                          subtitle: Text(
                              "$fuel_price per gallons / $fuel_amount gallons"),
                          trailing: Text(date),
                        );
                      }),
    );
  }
}
