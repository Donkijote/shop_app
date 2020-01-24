import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/product.dart';
import '../screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  /*final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);*/

  @override
  Widget build(BuildContext context) {
    var item = Provider.of<Product>(context);
    var cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.nameRoute, arguments: item.id);
          },
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(item.title),
          backgroundColor: Colors.black45,
          leading: IconButton(
            icon:
                Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              item.toogleFavoriteStatus();
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(item.id, item.price, item.title);
            },
          ),
        ),
      ),
    );
  }
}
