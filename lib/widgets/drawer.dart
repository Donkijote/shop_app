import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders.dart';
import '../screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello Friend!',
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              'Products',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
