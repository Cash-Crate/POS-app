import 'package:flutter/material.dart';
import '../widgets/left_panel.dart';
import '../models/products.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;

 // Delete product function
  void deleteProduct(String name) {
    setState(() {
      products.removeWhere((product) => product.name == name);
    });
  }

  // Edit product function 
  void editProduct(String name) {
    // Edit product logic
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
                                                  onPressed: () {
                                                    // Add product logic
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
                                                child: Image.asset(
                                                  product.image,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
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
                                                        onPressed: () => editProduct(product.id.toString()), 
                                                      ),
                                                    IconButton(
                                                        icon: Icon(Icons.delete, color: Colors.red),
                                                        onPressed: () => deleteProduct(product.name), 
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

                    // Search Field with Expansion Logic
                    isSearchExpanded
                        ? Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: searchController,
                                autofocus: true, // Automatically focuses on the search field
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


//Products_overview_screen
