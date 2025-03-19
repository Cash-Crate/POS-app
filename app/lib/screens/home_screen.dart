import 'package:flutter/material.dart';
import '/models/products.dart';
import '/widgets/product_card.dart';
import '/widgets/left_panel.dart';
import '/widgets/right_panel.dart';

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
  List<Product> filteredProducts = List.from(products);
  bool isSearchExpanded = false;
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    quantities = List<int>.filled(products.length, 0);
  }

  void updateCart() {
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;

        return Scaffold(
          key: _scaffoldKey,
          appBar: isTablet
              ? AppBar(
                  backgroundColor: Colors.lightBlue,
                  title: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: searchController,
                      onChanged: filterProducts,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  centerTitle: true,
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ["All", "Burgers", "Fries", "Rice Meals", "Drinks"]
                        .map((category) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: selectedCategory == category,
                                onSelected: (_) => filterByCategory(category),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    if (isTablet) const LeftPanel(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 3 : 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: isTablet ? 1.2 : 2,
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
                                  if (quantities[index] > 0) {
                                    quantities[index]--;
                                  }
                                });
                              },
                              onAddToCart: () {
                                setState(() {
                                  if (quantities[index] > 0) {
                                    cart[filteredProducts[index].name] = (cart[filteredProducts[index].name] ?? 0) + quantities[index];
                                    quantities[index] = 0;
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
                    if (isTablet) RightPanel(cart: cart, onUpdate: updateCart),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: !isTablet
              ? BottomAppBar(
                  color: Colors.lightBlue,
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
          drawer: isTablet ? null : Drawer(child: LeftPanel()),
          endDrawer: isTablet ? null : Drawer(child: RightPanel(cart: cart, onUpdate: updateCart)),
        );
      },
    );
  }
}