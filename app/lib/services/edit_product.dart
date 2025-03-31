import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/login_service.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;  // Add productId as a parameter

  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String itemName = '';
  String itemDesc = '';
  double price = 0.0;
  int quantity = 1;
  String imageUrl = '';
  
  // List of categories 
  final List<Map<String, String>> categories = [
    {"name": "Electronics"},
    {"name": "Clothing"},
    {"name": "Books"},
    {"name": "Furniture"},
    {"name": "Toy"},
    {"name": "Beverages"},
  ];

  String? selectedCategoryName; 

  // Fetch product data based on productId
  Future<void> fetchProductDetails() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/items/${widget.productId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

     
      String categoryName = data['item_type']; 
      
      setState(() {
        itemName = data['item_name'];
        itemDesc = data['description'];
        price = data['price'].toDouble();
        quantity = data['quantity'];
        imageUrl = data['item_image'];
        selectedCategoryName = categoryName; 
      });
    } else {
      print("Failed to load product: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails(); 
  }


  // Handle the update request
  Future<void> updateProduct() async {
    final url = Uri.parse('http://localhost:3000/api/items/${widget.productId}');  

    if (selectedCategoryName == null) {
      print("Please select a valid category");
      return;
    }

    // Fetch the access token
    String? token = await LoginService.getAccessToken(); 

    if (token == null || token.isEmpty) {
      print("No access token found");
      return;
    }

    final Map<String, dynamic> productData = {
      'item_name': itemName,
      'description': itemDesc,
      'item_image': imageUrl,
      'price': price,
      'quantity': quantity,
      'item_type': selectedCategoryName, 
    };

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  
      },
      body: jsonEncode(productData),
    );

    // Check the full response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Show success message
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully")));
    } else {
      // Handle failed response
    }

    Navigator.pop(context, true); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              width: 400, 
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Update Product", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      // Product Name Field
                      TextFormField(
                        initialValue: itemName,
                        decoration: InputDecoration(labelText: 'Product Name'),
                        onChanged: (value) => itemName = value,
                        validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                      ),

                      // Description Field
                      TextFormField(
                        initialValue: itemDesc,
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) => itemDesc = value,
                        validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      ),

                      // Image URL Field
                      TextFormField(
                        initialValue: imageUrl,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        onChanged: (value) => imageUrl = value,
                        validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                      ),

                      // Price Field
                      TextFormField(
                        initialValue: price.toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                        validator: (value) =>
                            (value!.isEmpty || double.tryParse(value) == null) ? 'Enter a valid price' : null,
                      ),

                      // Quantity Field
                      TextFormField(
                        initialValue: quantity.toString(),
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => quantity = int.tryParse(value) ?? 1,
                        validator: (value) =>
                            (value!.isEmpty || int.tryParse(value) == null) ? 'Enter a valid quantity' : null,
                      ),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCategoryName,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()
                        ),
                        dropdownColor: Colors.white,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                              value: category["name"],
                              child: Text(category["name"]!,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryName = value;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a category' : null,
                      ),

                      SizedBox(height: 20),

                      // Update Product Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1F3745),
                              foregroundColor: Color(0xFF3BDEB2),
                            ),
                            child: Text("Cancel"),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateProduct();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF1F3745),
                              backgroundColor: Color(0xFF3BDEB2),
                            ),
                            child: Text('Update'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
