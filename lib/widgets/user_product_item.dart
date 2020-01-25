import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/product_ne.dart';
import '../models/product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductNEScreen.routeName,
                    arguments: product.id);
              },
              color: Colors.amber,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
