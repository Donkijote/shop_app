import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('DonShop'),
      ),
      body: ProductsGrid(),
    );
    return scaffold;
  }
}
