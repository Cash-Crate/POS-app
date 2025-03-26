import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: {
        '/': (context) => const HomeScreen(),
        '/products': (context) => ProductsOverviewScreen(),
      },
    );
  }
}
