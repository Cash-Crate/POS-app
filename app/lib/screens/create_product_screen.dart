import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  int categoryId = 0;
  Uint8List? _imageBytes; 
  String? _imageName; 
  String description = '';


  final ImagePicker _picker = ImagePicker(); 

  // Function to pick an image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); 
      setState(() {
        _imageBytes = bytes;
        _imageName = pickedFile.name; 
      });
    }
  }

  Future<void> addProduct() async {
    final url = Uri.parse('http://localhost:8000/api/items/create/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'item_type': categoryId,
        'item_name': name,
        'item_desc' : description,
        'price': price,
        'item_image': _imageName
      }),
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
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Category ID'),
                keyboardType: TextInputType.number,
                onChanged: (value) => categoryId = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Category ID must be a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Description'),
                onChanged: (value) => description = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Price must be a valid number';
                  }
                  return null;
                },
              ),
              
              
              
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Choose Image'),
              ),
              SizedBox(height: 10),
              _imageBytes != null
                  ? Image.memory(_imageBytes!, height: 100) // Display image
                  : Text("No image selected"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addProduct();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}