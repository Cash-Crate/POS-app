import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/login_service.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String itemName = '';
  String itemDesc = '';
  double price = 0.0;
  int quantity = 1;
  String imageUrl = '';
  
  // List of categories 
  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryName; 

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

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
        'Authorization': 'Bearer $token',  // Include token
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      
      setState(() {
        categories = data.map((item) => {"name": item["item_type_name"]}).toList();
      });

      print("Categories Loaded: $categories"); // Debugging log
    } else {
      print("Failed to load categories: ${response.body}");
    }
  } catch (e) {
    print("Error fetching categories: $e");
  }
}


  // List for attributes
  List<Map<String, String>> attributes = [];
  TextEditingController attrNameController = TextEditingController();
  TextEditingController attrValueController = TextEditingController();

  // Add attribute
  void addAttribute() {
    if (attrNameController.text.isNotEmpty && attrValueController.text.isNotEmpty) {
      setState(() {
        attributes.add({
          "attr_name": attrNameController.text,
          "attr_value": attrValueController.text
        });
        attrNameController.clear();
        attrValueController.clear();
      });
    }
  }

  // Remove attribute
  void removeAttribute(int index) {
    setState(() {
      attributes.removeAt(index);
    });
  }

  Future<void> addProduct() async {
  final url = Uri.parse('http://localhost:3000/api/items/create');

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

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    },
    body: jsonEncode(productData),
  );

  if (response.statusCode == 201) {
    Navigator.pop(context, true);
  } else {
    print("Failed to add product: ${response.body}");
  }
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
                      Text("Add Product", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      // Product Name Field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Product Name'),
                        onChanged: (value) => itemName = value,
                        validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                      ),

                      // Description Field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) => itemDesc = value,
                        validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      ),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        onChanged: (value) => imageUrl = value,
                        validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                      ),

                      // Price Field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                        validator: (value) =>
                            (value!.isEmpty || double.tryParse(value) == null) ? 'Enter a valid price' : null,
                      ),

                      // Quantity Field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => quantity = int.tryParse(value) ?? 1,
                        validator: (value) =>
                            (value!.isEmpty || int.tryParse(value) == null) ? 'Enter a valid quantity' : null,
                      ),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,  
                          fillColor: Colors.white,  
                          border: OutlineInputBorder(),  
                        ),
                        dropdownColor: Colors.white,  
                        value: selectedCategoryName,
                        onChanged: (value) => setState(() => selectedCategoryName = value),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category["name"],
                            child: Text(
                              category["name"]!,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Select a category' : null,
                      ),


                      SizedBox(height: 20),

                      // buttons section
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
                              side: BorderSide(color: Colors.black),
                            ),
                            child: Text('Cancel'),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addProduct();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3BDEB2),
                              foregroundColor: Color(0xFF1F3745),
                              side: BorderSide(color: Colors.black),
                            ),
                            child: Text('Add'),
                          ),
                        ],
                      ),
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
