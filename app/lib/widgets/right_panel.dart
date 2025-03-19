import 'package:flutter/material.dart';
import '/models/products.dart';

class RightPanel extends StatefulWidget {
  final Map<String, int> cart;
  final VoidCallback onUpdate;

  const RightPanel({super.key, required this.cart, required this.onUpdate});

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cart.entries.fold(0, (sum, entry) {
      Product? product = products.firstWhere(
        (p) => p.name == entry.key,
        orElse: () => Product(name: "Unknown", price: 0, image: "", category: "Uncategorized"),
      );
      return sum + (product.price * entry.value);
    });

    return Container(
      width: 300,
      color: Colors.blue.shade50,
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
                        orElse: () => Product(name: "Unknown", price: 0, image: "", category: "Uncategorized"),
                      );

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/images/placeholder.jpg",
                                        height: 50, width: 50, fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("\₱${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
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
                                  ),
                                  Text(entry.value.toString(), style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        widget.cart[entry.key] = widget.cart[entry.key]! + 1;
                                        widget.onUpdate();
                                      });
                                    },
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
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order placed!")),
                    );
                    setState(() {
                      widget.cart.clear();
                      widget.onUpdate();
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.cart.isEmpty ? Colors.grey : Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }
}
