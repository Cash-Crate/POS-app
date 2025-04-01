import 'package:flutter/material.dart';
import '/models/products.dart';
import '/widgets/product_card.dart';
import '/widgets/left_panel.dart';
import '/widgets/right_panel.dart';
import 'dart:async';
import '../screens/login_screen.dart';
import '../services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<int> quantities;
  Map<String, int> cart = {};
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];
  bool isSearchExpanded = false;
  String selectedCategory = "All";
  bool isLoading = true;
  List<String> categories = ["All"];
  List<Product> products = [];
  Future<void> checkUserSession() async {
    bool expired = await LoginService.isTokenExpired();
    print("Is token expired? $expired");

    if (expired) {
      print("Token expired! Logging out...");
      await LoginService.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _loadProducts();
    checkUserSession(); 
    Timer.periodic(Duration(minutes: 5), (timer) {
      checkUserSession();
    });
  }
  void updateCart() {
    setState(() {});
  }
  void _loadCategories() {
    // Extract unique categories from fetched products
    final Set<String> uniqueCategories = products.map((p) => p.category).toSet();

    // Update the categories list
    setState(() {
      categories = ["All", ...uniqueCategories];
    });
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        bool matchesSearch = query.isEmpty || product.name.toLowerCase().contains(query.toLowerCase());
        bool matchesCategory = selectedCategory == "All" || product.category == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filterProducts(searchController.text);
    });
  }
  void _loadProducts() async {
    try {
      List<Product> fetchedProducts = await fetchProducts();
      setState(() {
        products = fetchedProducts.where((p) => p.quantity > 0).toList(); 
        filteredProducts = List.from(products);
        quantities = List<int>.filled(filteredProducts.length, 1);
        isLoading = false;
      });

      _loadCategories();
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 900;
        bool isBelowTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: isTablet
              ? AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,  
                  title: SizedBox(
                    width: 450,
                    height: 45,
                    child: TextField(
                      controller: searchController,
                      onChanged: filterProducts,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Color(0xFF3BDEB2)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF3BDEB2),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1F3745),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  centerTitle: true,
                )
              : null,
          body: Row(
            children: [
              if (isTablet) const LeftPanel(),
              const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
              
             
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          alignment: Alignment.centerLeft, 
                          width: double.maxFinite, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: categories.map((category) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ChoiceChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color: selectedCategory == category 
                                        ? Colors.white 
                                        : Color(0xFF3BDEB2), 
                                  ),
                                ),
                                selected: selectedCategory == category,
                                selectedColor: Color(0xFF176B5D), 
                                backgroundColor: Color(0xFF1F3745), 
                                onSelected: (_) => filterByCategory(category),
                              ),
                            )).toList(),
                          ),
                        ),
                      ),
                    ),


                    // Products Grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: constraints.maxWidth >= 901 && constraints.maxWidth <= 1265
                                ? 2
                                : isTablet
                                    ? 3
                                    : isBelowTablet
                                        ? 2
                                        : 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: isTablet ? 1.3 : isBelowTablet ? 1.7 : 2,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              quantity: quantities[index],
                              onAdd: () {
                                setState(() {
                                  quantities[index]++;
                                });
                              },
                              onRemove: () {
                                setState(() {
                                  if (quantities[index] > 1) {
                                    quantities[index]--;
                                  }
                                });
                              },
                              onAddToCart: () {
                                setState(() {
                                  if (quantities[index] > 0) {
                                    cart[filteredProducts[index].name] = (cart[filteredProducts[index].name] ?? 0) + quantities[index];
                                    quantities[index] = 1;
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${filteredProducts[index].name} added to cart!'),
                                  ),
                                );
                                updateCart();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (isTablet) ...[
                const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
                RightPanel(cart: cart, onUpdate: updateCart),
              ]
            ],
          ),

          bottomNavigationBar: !isTablet
              ? BottomAppBar(
                  color: Color(0xFF1F3745),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSearchExpanded ? 200 : 50,
                        child: isSearchExpanded
                            ? TextField(
                                controller: searchController,
                                onChanged: filterProducts,
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: Color(0xFF1F3745)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onSubmitted: (_) {
                                  setState(() {
                                    isSearchExpanded = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.search, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    isSearchExpanded = true;
                                  });
                                },
                              ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                )
              : null,
          drawer: !isTablet ? Drawer(child: LeftPanel()) : null,
          endDrawer: !isTablet ? Drawer(child: RightPanel(cart: cart, onUpdate: updateCart)) : null,
        );
      },
    );
  }
}