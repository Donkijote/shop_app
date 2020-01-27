import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orders.orders.length > 0
              ? ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
                )
              : Center(
                  child: Text(
                    'No orders yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
    );
  }
}
