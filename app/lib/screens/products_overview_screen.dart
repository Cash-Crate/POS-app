import 'package:app/services/edit_product.dart';
import 'package:flutter/material.dart';
import '../widgets/left_panel.dart';
import '../models/products.dart';
import '../services/create_product.dart';
import '../services/delete_product.dart';



class ProductsOverviewScreen extends StatefulWidget {
  
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;

 // Delete product function
  void deleteProduct(String name) {
    setState(() {
      products.removeWhere((product) => product.name == name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: isTablet
              ? AppBar(
                  backgroundColor: Colors.white,
                  title: SizedBox(
                    width: 450,
                    height: 45,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Color(0xFF3BDEB2)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF3BDEB2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1F3745),
                      ),
                    ),
                  ),
                  centerTitle: true,
                )
              : null,
          body: Row(
            children: [
              if (isTablet) const LeftPanel(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),

                      // Product Table
                      Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal, 
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: DataTable(
                                      columnSpacing: 20,
                                      headingRowColor: WidgetStateProperty.all(Color(0xFF1F3745)),
                                      headingTextStyle: TextStyle(
                                        color: Color(0xFF3BDEB2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(label: Text('ID')),
                                        DataColumn(label: Text('Image')),
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Price')),
                                        DataColumn(label: Text('Category')),
                                        DataColumn(
                                          label: SizedBox(
                                            width: 80,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                height: 35,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF3BDEB2),
                                                  borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.add, color: Color(0xFF1F3745)),
                                                  onPressed: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => CreateProductScreen()),
                                                    );

                                                    if (result == true) {
                                                      fetchProducts(); 
                                                    }
                                                  },
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: products.map((product) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(product.id.toString())), 
                                            DataCell(
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                child: product.image.startsWith("http") 
                                                    ? Image.network(
                                                        product.image,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Image.asset("assets/images/placeholder.jpg", width: 50, height: 50);
                                                        },
                                                      )
                                                    : Image.asset(product.image, width: 50, height: 50, fit: BoxFit.cover),
                                              ),
                                            ),
                                            DataCell(Text(product.name)),
                                            DataCell(Text("\₱${product.price.toStringAsFixed(2)}")),
                                            DataCell(Text(product.category)),
                                            DataCell(
                                              SizedBox(
                                                width: 100,
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                    IconButton(
                                                      icon: Icon(Icons.edit, color: Colors.blue),
                                                      onPressed: () async {
                                                        final result = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => EditProductScreen(productId: product.id) 
                                                          ),
                                                        );

                                                        if (result == true) {
                                                          fetchProducts();
                                                        }
                                                      },
                                                    ),

                                                    IconButton(
                                                      icon: Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text('Delete Product'),
                                                              content: Text('Are you sure you want to delete ${product.name}?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    bool success = await DeleteProductService.deleteProduct(product.id); 

                                                                    Navigator.pop(context); 

                                                                    if (success) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text("Product deleted successfully")),
                                                                      );

                                                                      // Refresh UI once the product is deleted
                                                                      setState(() {
                                                                        products.removeWhere((p) => p.id == product.id);
                                                                      });
                                                                    } else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text("Failed to delete product")),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Text('Yes'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context); 
                                                                  },
                                                                  child: Text('No'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),

                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      

                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: !isTablet ? Drawer(child: LeftPanel()) : null,



          bottomNavigationBar: !isTablet
            ? BottomAppBar(
                color: Color(0xFF1F3745),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Menu Icon Button
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),

                    
                    isSearchExpanded
                        ? Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: searchController,
                                autofocus: true, 
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: Color(0xFF3BDEB2)),
                                  prefixIcon: const Icon(Icons.search, color: Color(0xFF3BDEB2)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        isSearchExpanded = false;
                                        searchController.clear();
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF1F3745),
                                ),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                isSearchExpanded = true;
                              });
                            },
                          ),
                  ],
                ),
              )
            : null,

        );
      }, 
    );
  }
}