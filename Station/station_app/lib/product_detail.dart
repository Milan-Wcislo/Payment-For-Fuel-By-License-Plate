import 'package:flutter/material.dart';
import 'package:station_app/models/product.dart';
import 'package:station_app/authentication/auth_service.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  final AuthService authService = AuthService();

  ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff10316B),
        title: Text(
          product.name,
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 24.0,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(
                    'http://10.0.2.2:8000/${product.image}',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                authService.buyProduct(product.id);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff10316B),
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bolt,
                    color: Color(0xfff4ce14),
                    size: 38.0,
                  ),
                  Text(
                    '${product.price}',
                    style: const TextStyle(fontSize: 32),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
