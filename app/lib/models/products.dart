import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/login_service.dart';

class Product {
  final int id; 
  final String name;
  final double price;
  final String description;
  final String image;
  final String category;

  Product({
    required this.id, 
    required this.name,
    required this.price,
    required this.description,
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
      description: json['description'] ?? '',
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      image: hasValidImage
          ? "http://localhost:3000/uploads/$imageUrl"
          : "assets/images/placeholder.jpg", 
      category: json["item_type"] ?? "Uncategorized",
    );
  }

}



// fetch data from the API
Future<List<Product>> fetchProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = await LoginService.getAccessToken(); 

  if (token == null || token.isEmpty) {
    throw Exception("No access token found");
  }

  final response = await http.get(
    Uri.parse('http://localhost:3000/api/items'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> productList = jsonDecode(response.body);
    return productList.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load products. Status code: ${response.statusCode}");
  }
}



