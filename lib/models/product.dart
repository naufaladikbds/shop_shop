import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String? token;
  bool isFavorite;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.token,
  });

  final String hostUrl =
      'https://shop-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<void> toggleFavorite({required String userId}) async {
    isFavorite = !isFavorite;
    notifyListeners();

    Uri parsedUrl =
        Uri.parse('$hostUrl/userFavorites/$userId/$id.json?auth=${token}');
    final req = isFavorite;

    try {
      final response = await http.put(
        parsedUrl,
        body: json.encode(req),
      );

      final bool responseBody = jsonDecode(response.body);

      // if (responseBody['error'] != null) {
      //   throw HttpException(
      //       message: '${response.statusCode}: ${responseBody['error']}');
      // }

      print(responseBody);
      print(response.statusCode);
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(message: '$e');
    }
  }
}
