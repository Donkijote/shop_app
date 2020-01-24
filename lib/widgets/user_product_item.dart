import 'package:flutter/material.dart';

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
              onPressed: () {},
              color: Colors.amber,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
