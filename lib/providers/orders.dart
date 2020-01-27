import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';
import '../models/orders.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopstore-64cc5.firebaseio.com/orders.json';
    final time = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': time.toIso8601String(),
        'products': cartProducts
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: time,
          products: cartProducts),
    );
    notifyListeners();
  }
}
