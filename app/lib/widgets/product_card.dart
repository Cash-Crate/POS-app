import 'package:flutter/material.dart';
import '/models/products.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 600;

    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageWithQuantityControls(isTablet),
                    const SizedBox(width: 8),
                    Expanded(child: _buildProductDetails(isTablet, Alignment.centerLeft)),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildImageWithQuantityControls(isTablet),
                    const SizedBox(width: 16),
                    Expanded(child: _buildProductDetails(isTablet, Alignment.center)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImageWithQuantityControls(bool isTablet) {
    double imageSize = isTablet ? 120 : 110;
    return Column(
      children: [
        SizedBox(
          height: imageSize,
          width: imageSize,
          child: Image.asset(
            widget.product.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/placeholder.jpg",
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: widget.onRemove,
            ),
            Text(
              widget.quantity.toString(),
              style: TextStyle(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: widget.onAdd,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductDetails(bool isTablet, Alignment alignment) {
    return Column(
      crossAxisAlignment: isTablet ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: isTablet ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Text(
          widget.product.name,
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: isTablet ? 18 : 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "\₱${widget.product.price.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 14, color: Colors.green),
        ),
        SizedBox(height: isTablet ? 85 : 10),
        Align(
          alignment: alignment,
          child: ElevatedButton(
            onPressed: widget.onAddToCart,
            child: const Text("Add"),
          ),
        ),
      ],
    );
  }
}