class Product {
  final int id;
  final String name;
  final String image;
  final String description;
  final int price;
  final bool isBestseller;
  final DateTime updatedAt;
  final int category;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.isBestseller,
    required this.updatedAt,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      isBestseller: json['is_bestseller'] as bool,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['category'] as int,
    );
  }
}
