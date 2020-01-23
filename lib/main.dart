import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products.dart';
import './screens/product_detail.dart';

import './providers/cart.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
