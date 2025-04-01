import 'package:flutter/material.dart';
import '/models/products.dart';
import '../services/sell_items.dart'; // Import the product service

class RightPanel extends StatefulWidget {
  final Map<String, int> cart;
  final VoidCallback onUpdate;

  const RightPanel({super.key, required this.cart, required this.onUpdate});
  
  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      List<Product> fetchedProducts = await fetchProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }
  Future<void> _placeOrder() async {
    bool allItemsSuccessful = true; 
    List<int> soldOutItems = []; 

    for (var entry in widget.cart.entries) {
      Product? product = products.firstWhere(
        (p) => p.name == entry.key,
        orElse: () => Product(id: 0, name: "Unknown", price: 0, image: "", category: "Uncategorized", description: ""),
      );

      int itemId = product.id;
      int quantity = entry.value;

      bool success = await ProductService.sellItem(itemId, quantity);

      if (success) {
        if (product.quantity - quantity <= 0) {
          soldOutItems.add(itemId); 
        }
      } else {
        allItemsSuccessful = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Not enough stock for ${product.name}."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() {
      for (int id in soldOutItems) {
        products.removeWhere((p) => p.id == id);
      }
      widget.cart.clear(); 
    });

    widget.onUpdate();
    
    if (allItemsSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cart.entries.fold(0, (sum, entry) {
      Product? product = products.firstWhere(
        (p) => p.name == entry.key,
        orElse: () => Product(id: 0, name: "Unknown", price: 0, image: "", category: "Uncategorized", description: ""),
      );
      return sum + (product.price * entry.value);
    });

    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cart Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          Expanded(
            child: widget.cart.isEmpty
                ? const Center(child: Text("Your cart is empty"))
                : ListView(
                    children: widget.cart.entries.map((entry) {
                      Product? product = products.firstWhere(
                        (p) => p.name == entry.key,
                        orElse: () => Product(id: 0, name: "Unknown", price: 0, image: "", category: "Uncategorized", description: ""),
                      );
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/images/placeholder.jpg",
                                        height: 40, width: 40, fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("₱${product.price.toStringAsFixed(2)}"),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Container(
                                      width: 14, 
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1F3745), 
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.remove, color: Color(0xFF3BDEB2), size: 10), 
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (widget.cart[entry.key]! > 1) {
                                          widget.cart[entry.key] = widget.cart[entry.key]! - 1;
                                        } else {
                                          widget.cart.remove(entry.key);
                                        }
                                        widget.onUpdate();
                                      });
                                    },
                                    padding: EdgeInsets.zero, 
                                    constraints: BoxConstraints(), 
                                  ),
                                  Text(entry.value.toString(), style: const TextStyle(fontSize: 14)), 
                                  IconButton(
                                    icon: Container(
                                      width: 14, // Same small size
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1F3745), 
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.add, color: Color(0xFF3BDEB2), size: 10), 
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cart[entry.key] = widget.cart[entry.key]! + 1;
                                        widget.onUpdate();
                                      });
                                    },
                                    padding: EdgeInsets.zero, 
                                    constraints: BoxConstraints(), 
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("\₱${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.cart.isEmpty
                ? null
                : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.cart.isEmpty ? Colors.grey : Color(0xFF3BDEB2),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Place Order", style: TextStyle(color: Color(0xFF1F3745)),),
          ),
        ],
      ),
    );
  }
}
