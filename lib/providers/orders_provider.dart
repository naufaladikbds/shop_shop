import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_shop/models/http_exception.dart';
import 'package:shop_shop/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrdersProvider extends ChangeNotifier {
  final String? token;

  OrdersProvider({this.token});

  final String hostUrl =
      'https://shop-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  final List<OrderItem> _orderList = [];
  bool hasError = false;

  List<OrderItem> get orderList {
    return [..._orderList];
  }

  Future<void> fetchOrders({required String? userId}) async {
    final Uri parsedUrl =
        Uri.parse('$hostUrl/orders/$userId.json?auth=${token}');

    try {
      final response = await http.get(parsedUrl);
      final Map? responseBody = jsonDecode(response.body);

      if (responseBody == null) {
        throw HttpException(message: 'You have not made any orders');
      }

      if (responseBody['error'] != null &&
          (responseBody['error'] as String).contains('denied')) {
        throw HttpException(
            message: 'Token expired, please login to refresh your session');
      }

      if (responseBody.isNotEmpty) {
        _orderList.clear();
        print(responseBody);

        responseBody.forEach((key, value) {
          List<CartItem> tempList = [];

          for (var item in value['orderList']) {
            tempList.add(
              CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              ),
            );
          }

          _orderList.insert(
            0,
            OrderItem(
              id: key,
              orderList: tempList,
              totalPrice: value['totalPrice'],
              orderDate: DateTime.parse(value['orderDate']),
            ),
          );
        });
        hasError = false;
      } else {
        hasError = true;
        notifyListeners();
        throw HttpException(message: 'No orders were found in the database');
      }
    } catch (e) {
      hasError = true;

      notifyListeners();
      throw HttpException(message: e.toString());
    }
    notifyListeners();
  }

  Future<void> addToOrder(List<CartItem> cartItems,
      {required String userId}) async {
    final Uri parsedUrl =
        Uri.parse('$hostUrl/orders/$userId.json?auth=${token}');

    DateTime currentDate = DateTime.now();

    double totalCartPrice = 0;
    for (var item in cartItems) {
      totalCartPrice += item.price * item.quantity;
    }

    _orderList.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        orderList: cartItems,
        totalPrice: totalCartPrice,
        orderDate: currentDate,
      ),
    );

    final requestBody = {
      'orderList': cartItems
          .map(
            (e) => {
              'id': e.id,
              'title': e.title,
              'price': e.price,
              'quantity': e.quantity,
            },
          )
          .toList(),
      'totalPrice': totalCartPrice,
      'orderDate': currentDate.toIso8601String(),
    };

    try {
      final response = await http.post(
        parsedUrl,
        body: json.encode(requestBody),
      );

      final responseBody = json.decode(response.body);

      print(responseBody);
    } catch (e) {
      _orderList.removeAt(0);
      notifyListeners();
      throw HttpException(message: e.toString());
    }

    notifyListeners();
  }

  void removeFromOrder(String productId) {
    _orderList.removeWhere((element) => element.id == productId);
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final List<CartItem> orderList;
  final double totalPrice;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.orderList,
    required this.totalPrice,
    required this.orderDate,
  });
}
