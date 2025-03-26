class Product {
  final int id; // Add ID field
  final String name;
  final double price;
  final String image;
  final String category;

  Product({
    required this.id, // Require ID in constructor
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}

// Auto-generate IDs based on index
List<Product> products = [
  Product(id: 1, name: "Burger", price: 120, image: "assets/images/siken.jpg", category: "Burgers"),
  Product(id: 2, name: "Sisig", price: 120, image: "assets/images/siken.jpg", category: "Rice Meals"),
  Product(id: 3, name: "Fries", price: 60, image: "assets/images/siken.jpg", category: "Fries"),
  Product(id: 4, name: "Pepsi", price: 25, image: "assets/images/siken.jpg", category: "Drinks"),
  Product(id: 5, name: "Extra Rice", price: 20, image: "assets/images/siken.jpg", category: "Rice Meals"),
  Product(id: 6, name: "Fried Chicken", price: 130, image: "assets/images/siken.jpg", category: "Rice Meals"),
];
