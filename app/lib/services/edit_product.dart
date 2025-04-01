import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/login_service.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;  

  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();


  // List to store categories>
  List<Map<String, dynamic>> categories = [];  
  String? selectedCategoryName; 


  Future<void> fetchCategories() async {
    final url = Uri.parse('http://localhost:3000/api/itemtypes');

    try {
      // Fetch the access token
      String? token = await LoginService.getAccessToken(); 

      if (token == null || token.isEmpty) {
        print("No access token found");
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        
        setState(() {
          categories = data.map((item) => {"name": item["item_type_name"]}).toList();
        });
        // Debugging logs
        print("Categories Loaded: $categories"); 
      } else {
        print("Failed to load categories: ${response.body}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchProductDetails() async {
    final url = Uri.parse('http://localhost:3000/api/items/${widget.productId}');

    try {
      String? token = await LoginService.getAccessToken();
      if (token == null || token.isEmpty) {
        print("No access token found");
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          itemNameController.text = data['item_name'];
          itemDescController.text = data['description'];
          priceController.text = data['price'].toString();
          quantityController.text = data['quantity'].toString();
          imageUrlController.text = data['item_image'];
          selectedCategoryName = data['item_type'];
        });

        print("Product details loaded successfully.");
      } else {
        print("Failed to load product: ${response.body}");
      }
    } catch (e) {
      print("Error fetching product details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails(); 
    fetchCategories();
  }
  
  Future<void> updateProduct() async {
    final url = Uri.parse('http://localhost:3000/api/items/${widget.productId}');  

    if (selectedCategoryName == null) {
      print("Please select a valid category");
      return;
    }

    String? token = await LoginService.getAccessToken(); 

    if (token == null || token.isEmpty) {
      print("No access token found");
      return;
    }

    final Map<String, dynamic> productData = {
      'item_name': itemNameController.text,
      'description': itemDescController.text,
      'item_image': imageUrlController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'quantity': int.tryParse(quantityController.text) ?? 1,
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

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully")));
    } else {
      // Handle error
    }
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    itemDescController.dispose();
    priceController.dispose();
    quantityController.dispose();
    imageUrlController.dispose();
    super.dispose();
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
                        controller: itemNameController,
                        decoration: InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                      ),

                      // Description Field
                      TextFormField(
                        controller: itemDescController,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      ),

                      // Image URL Field
                      TextFormField(
                        controller: imageUrlController,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                      ),

                      // Price Field
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            (value!.isEmpty || double.tryParse(value) == null) ? 'Enter a valid price' : null,
                      ),

                      // Quantity Field
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
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

                      // Buttons
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
