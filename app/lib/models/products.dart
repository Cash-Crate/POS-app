class Product {
  final String name;
  final double price;
  final String image;
  final String category;

  Product({required this.name, required this.price, required this.image, required this.category});
}

List<Product> products = [
  Product(name: "Burger", price: 120, image: "assets/images/burger.jpg", category: "Burgers"),
  Product(name: "Sisig", price: 120, image: "assets/images/sisig.jpg", category: "Rice Meals"),
  Product(name: "Fries", price: 60, image: "assets/images/fries.jpg", category: "Fries"),
  Product(name: "Pepsi", price: 25, image: "assets/images/pepsi.jpg", category: "Drinks"),
  Product(name: "Extra Rice", price: 20, image: "assets/images/extra-rice.jpg", category: "Rice Meals"),
  Product(name: "Fried Chicken", price: 130, image: "assets/images/siken.jpg", category: "Rice Meals"),
];