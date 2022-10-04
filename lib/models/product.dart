import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
  });

  final String hostUrl =
      'https://shop-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    Uri parsedUrl = Uri.parse('$hostUrl/products/$id.json');
    final req = {'isFavorite': isFavorite};

    try {
      final response = await http.patch(
        parsedUrl,
        body: json.encode(req),
      );

      final responseBody = jsonDecode(response.body);

      print(responseBody);
      print(response.statusCode);
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(message: 'Caught Error: $e');
    }
  }
}
