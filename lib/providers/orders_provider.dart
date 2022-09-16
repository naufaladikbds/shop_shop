import 'package:flutter/cupertino.dart';
import 'package:shop_shop/providers/cart_provider.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderItem> _orderList = [];

  List<OrderItem> get orderList {
    return [..._orderList];
  }

  void addToOrder(List<CartItem> cartItems) {
    double totalCartPrice = 0;
    for (var item in cartItems) {
      totalCartPrice += item.price * item.quantity;
    }

    _orderList.add(
      OrderItem(
        id: DateTime.now().toString(),
        orderList: cartItems,
        totalPrice: totalCartPrice,
        orderDate: DateTime.now(),
      ),
    );

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
