import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // do error handlling
              return Center(
                child: Text('An error Ocurred'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, _) => ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
