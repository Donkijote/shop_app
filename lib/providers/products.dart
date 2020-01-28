import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
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
      description: 'Cool, Cooler, Coolest.',
      price: 186.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/576/57614/196x196/43c28887a1757b494ef892644.jpg',
    ),
    Product(
      id: 'p9',
      title: 'Western Digital WD Black, 2 TB',
      description: 'out of space? No more with WD.',
      price: 186.99,
      imageUrl:
          'https://static-geektopia.com/storage/t/i/489/48944/196x196/a3396f05296a9e10e1713af01.jpg',
    ),*/
  ];

  final String token;
  final String userId;

  Products(this.token, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shopstore-64cc5.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.get(url);
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData == null) {
        return;
      }
      final favoriteResp = await http.get(
          'https://shopstore-64cc5.firebaseio.com/userFavorites/$userId.json?auth=$token');
      final decodedFavorite = json.decode(favoriteResp.body);
      final List<Product> loadedProducts = [];
      decodedData.forEach((prodId, prodData) {
        loadedProducts.insert(
          0,
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: decodedFavorite == null
                ? false
                : decodedFavorite[prodId] ?? false,
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopstore-64cc5.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product updates) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopstore-64cc5.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(
        url,
        body: json.encode({
          'title': updates.title,
          'price': updates.price,
          'imageUrl': updates.imageUrl,
          'description': updates.description,
        }),
      );
      _items[prodIndex] = updates;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopstore-64cc5.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex = _items.indexWhere((p) => p.id == id);
    var exinstingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final resp = await http.delete(url);
    if (resp.statusCode >= 400) {
      _items.insert(existingProductIndex, exinstingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    exinstingProduct = null;
  }
}
