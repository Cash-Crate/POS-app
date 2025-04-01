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
  TextEditingController attrNameController = TextEditingController(); 
  TextEditingController attrValueController = TextEditingController(); 


  // List to store categories
  List<Map<String, dynamic>> categories = [];  
  String? selectedCategoryName; 

  Future<void> fetchCategories() async {
    final url = Uri.parse('http://localhost:3000/api/itemtypes');

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
        List<dynamic> data = jsonDecode(response.body);
        
        setState(() {
          categories = data.map((item) => {"name": item["item_type_name"]}).toList();
        });
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
    // Update Product Data
    final productUrl = Uri.parse('http://localhost:3000/api/items/${widget.productId}');  

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

    // Update product details first
    final productResponse = await http.put(
      productUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  
      },
      body: jsonEncode(productData),
    );

    if (productResponse.statusCode == 200) {
      print("Product updated successfully");
    } else {
      print("Failed to update product: ${productResponse.body}");
    }

    // Update Attribute if provided
    if (attrNameController.text.isNotEmpty && attrValueController.text.isNotEmpty) {
      final attrUrl = Uri.parse('http://localhost:3000/api/items/attrs/${widget.productId}/${attrNameController.text}');
      
      final Map<String, dynamic> attributeData = {
        'attr_value': attrValueController.text,
      };

      final attrResponse = await http.put(
        attrUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(attributeData),
      );

      if (attrResponse.statusCode == 200) {
        print("Attribute updated successfully");
      } else {
        print("Failed to update attribute: ${attrResponse.body}");
      }
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product and attribute updated successfully")));
    Navigator.pop(context, true);
  }


  @override
  void dispose() {
    itemNameController.dispose();
    itemDescController.dispose();
    priceController.dispose();
    quantityController.dispose();
    imageUrlController.dispose();
    attrNameController.dispose();  
    attrValueController.dispose(); 
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
                          return DropdownMenuItem<String>(value: category["name"], child: Text(category["name"]));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryName = value;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a category' : null,
                      ),

                      // New attr_name Field
                      TextFormField(
                        controller: attrNameController,
                        decoration: InputDecoration(labelText: 'Attribute Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter an attribute name' : null,
                      ),

                      // New attr_value Field
                      TextFormField(
                        controller: attrValueController,
                        decoration: InputDecoration(labelText: 'Attribute Value'),
                        validator: (value) => value!.isEmpty ? 'Please enter an attribute value' : null,
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
