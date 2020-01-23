import 'package:flutter/material.dart';

import './screens/products.dart';
import './screens/product_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepPurple,
        fontFamily: 'Lato',
      ),
      home: ProductsScreen(),
      routes: {
        ProductDetailScreen.nameRoute: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
