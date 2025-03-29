import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id; 
  final String name;
  final double price;
  final String image;
  final String category;

  Product({
    required this.id, 
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  // Factory method to convert JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
  String? imageUrl = json["item_image"];
  bool hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

  return Product(
      id: json["item_id"] ?? 0,
      name: json["item_name"] ?? "No Name",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      image: hasValidImage
          ? "http://localhost:8000/uploads/$imageUrl"
          : "assets/images/placeholder.jpg", // ✅ Use placeholder if missing
      category: json["item_type_name"] ?? "Uncategorized",
    );
  }

}

// Add the fetchProducts() function to fetch data from the API
Future<List<Product>> fetchProducts() async {
  const String apiUrl = "http://localhost:8000/api/items/";
  
  final response = await http.get(Uri.parse(apiUrl));
  
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load products. Status code: ${response.statusCode}");
  }
}


