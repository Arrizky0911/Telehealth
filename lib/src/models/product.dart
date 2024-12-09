class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final String ingredients;
  final int stock;
  final double rating;
  final int totalReviews;

  Product({
    required this.id,
    required this.name, 
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.ingredients,
    this.stock = 0,
    this.rating = 0,
    this.totalReviews = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      ingredients: map['ingredients'] ?? '',
      stock: map['stock'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
    );
  }

}
