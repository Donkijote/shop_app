import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'AMD Ryzen 7 3800X',
      description: 'Best processor ever!',
      price: 380.85,
      imageUrl:
          'https://www.infor-ingen.com/tienda/image/cache/catalog/Logos%20Marcas/proces/7-3-500x500.jpg',
    ),
    Product(
      id: 'p2',
      title: 'X570 Gaming Pro Carbon WiFi MPG',
      description: 'MSI motherboard next gen.',
      price: 248.40,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/656/65698/150x150/product_10_20190527133016.png',
    ),
    Product(
      id: 'p3',
      title: 'GeForce RTX 2080 Ti',
      description: 'Nvidia so far best graphic card.',
      price: 1109.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/577/57768/150x150/geforce-rtx-2080-ti-web-t.png',
    ),
    Product(
      id: 'p4',
      title: 'Predator RGB, 16 GB (2x 8 GB), DDR4-2933, CL 15',
      description: 'Last gen RAM best memories',
      price: 119.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/605/60552/150x150/e98f7bbb592fc9f9a0f66bf95.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Samsung 970 EVO Plus, 250 GB',
      description: 'Best SSD for highest performance',
      price: 87.10,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/641/64110/196x196/97a40436c091dd2cad2857646.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Corsair HX1000i',
      description: 'Power! Power! and more Power with Corsair',
      price: 227.90,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/342/34291/196x196/f158c9d79909fcfe94d82f641.jpg',
    ),
    Product(
      id: 'p7',
      title: 'Thermaltake View 71 TG RGB',
      description: 'Beautiful cases for you pc!',
      price: 227.90,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/466/46691/196x196/ca-1i7-00f1wn-01_2dc7122b.jpg',
    ),
    Product(
      id: 'p8',
      title: 'Corsair H150i Pro',
      description: 'Cool, Cooler, Coolest ',
      price: 186.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/576/57614/196x196/43c28887a1757b494ef892644.jpg',
    ),
    Product(
      id: 'p9',
      title: 'Western Digital WD Black, 2 TB',
      description: 'out of space? No more with WD ',
      price: 186.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/489/48944/196x196/a3396f05296a9e10e1713af01.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> addProduct(Product product) {
    const url = 'https://shopstore-64cc5.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'description': product.description,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((resp) {
      final newProduct = Product(
        id: json.decode(resp.body)['name'],
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      );

      _items.add(newProduct);

      notifyListeners();
    });
  }

  void updateProduct(String id, Product updates) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = updates;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
