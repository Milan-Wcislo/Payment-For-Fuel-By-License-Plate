import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:station_app/models/category.dart';
import 'dart:convert';

import 'package:station_app/models/product.dart';
import 'package:station_app/product_detail.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  static const String baseUrl = 'http://10.0.2.2:8000';
  List<Product> products = [];
  List<Category> categories = [];

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  _fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products/'));
    if (response.statusCode == 200) {
      var productsData = jsonDecode(response.body)["products"];
      List<Product> fetchedProducts = [];
      for (Map<String, dynamic> item in productsData) {
        fetchedProducts.add(Product.fromJson(item));
      }
      var categoriesData = jsonDecode(response.body)["categories"];
      List<Category> fetchedCategories = [];
      for (Map<String, dynamic> item in categoriesData) {
        fetchedCategories.add(Category.fromJson(item));
      }
      setState(() {
        products = fetchedProducts;
        categories = fetchedCategories;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          List<Product> filteredProducts = products
              .where(
                  (product) => product.category == categories[categoryIndex].id)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    categories[categoryIndex].name,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetail(product: filteredProducts[index]),
                        ),
                      );
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 30),
                              child: FractionallySizedBox(
                                widthFactor:
                                    0.8, // Adjust this factor as needed
                                heightFactor:
                                    0.8, // Adjust this factor as needed
                                child: Image.network(
                                  '$baseUrl/${filteredProducts[index].image}',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading image: $error');
                                    return const Placeholder(); // Placeholder image or another fallback
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: const Color(0xfff5f7f8),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt, // Replace with the bolt icon
                                    color: Color(0xfff4ce14),
                                    size: 32.0,
                                  ),
                                  Text(
                                    '${filteredProducts[index].price}', // Change this to your product price
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          18.0, // Adjust the font size as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filteredProducts[index].name,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
