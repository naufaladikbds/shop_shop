import 'package:flutter/cupertino.dart';
import 'package:shop_shop/providers/cart_provider.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderItem> _orderList = [
    OrderItem(
      id: '000',
      orderList: [
        CartItem(
          id: '01',
          title: "Sunday Bruh",
          price: 192.84,
          quantity: 5,
        ),
        CartItem(
          id: '02',
          title: "Action Figure",
          price: 823.84,
          quantity: 2,
        ),
      ],
      totalPrice: 856.23,
      orderDate: DateTime.now(),
    ),
    OrderItem(
      id: '001',
      orderList: [
        CartItem(
          id: '05',
          title: "Item 1",
          price: 192.84,
          quantity: 5,
        ),
        CartItem(
          id: '06',
          title: "Item 2",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
        CartItem(
          id: '06',
          title: "Item 3",
          price: 823.84,
          quantity: 2,
        ),
      ],
      totalPrice: 856.23,
      orderDate: DateTime.now(),
    ),
  ];

  List<OrderItem> get orderList {
    return [..._orderList];
  }

  void addToOrder(List<CartItem> cartItems) {
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
