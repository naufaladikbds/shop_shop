import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_shop/models/http_exception.dart';
import 'package:shop_shop/models/product.dart';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final String hostUrl =
      'https://shop-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // bool isShowFavoritesOnly = false;

  List<Product> get items {
    // if (isShowFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Future<void> fetchProducts() async {
    final Uri parsedUrl = Uri.parse('$hostUrl/products.json');

    try {
      final response = await http.get(parsedUrl);

      final Map? responseBody = json.decode(response.body);

      List<Product> productList = [];

      responseBody?.forEach((key, value) {
        productList.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
          ),
        );
      });

      return Future.delayed(Duration(milliseconds: 400), () {
        _items = productList;
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void clearProducts() {
    _items.clear();
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Product searchItemById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct({
    required String id,
    required double price,
    required String description,
    required String title,
    required String imageUrl,
    required bool isFavorite,
  }) async {
    final Uri parsedUrl = Uri.parse('$hostUrl/products.json');

    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };

    var res = await http.post(
      parsedUrl,
      body: json.encode(requestBody),
    );

    return Future.delayed(Duration(seconds: 1), () {
      _items.add(
        Product(
          id: json.decode(res.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
          isFavorite: isFavorite,
        ),
      );
      notifyListeners();
    });
  }

  Future<void> editProduct(Product product) async {
    Uri parsedUrl = Uri.parse('$hostUrl/products/${product.id}.json');

    final requestBody = {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };

    await http.patch(parsedUrl, body: json.encode(requestBody));
    // final responseBody = json.decode(response.body);

    int existingItemIndex = _items.indexWhere((e) => e.id == product.id);
    _items.removeWhere((e) => e.id == product.id);
    _items.insert(existingItemIndex, product);
    notifyListeners();
  }

  Future<void> removeProduct(String productId) async {
    Uri parsedUrl = Uri.parse('$hostUrl/products/${productId}.json');
    final targetProductIndex =
        _items.indexWhere((element) => element.id == productId);

    try {
      final response = await http.delete(parsedUrl);
      if (response.statusCode >= 400) {
        print(1);
        throw HttpException(message: 'Something happened boiiii');
      } else {
        _items.removeAt(targetProductIndex);
      }
    } catch (e) {
      print(2);
      print(e.toString());
      print(3);
      rethrow;
    }

    notifyListeners();
  }

  // void toggleShowFavoritesOnly() {
  //   isShowFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void toggleShowAll() {
  //   isShowFavoritesOnly = false;
  //   notifyListeners();
  // }
}
