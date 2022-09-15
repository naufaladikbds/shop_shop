import 'package:flutter/cupertino.dart';
import 'package:shop_shop/models/product.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartQuantity {
    int count = 0;
    _items.forEach((key, value) {
      count += value.quantity;
    });
    return count;
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addToCart(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items[id]?.quantity++; // OR USE .Update()
    } else {
      _items.addAll(
        {
          id: CartItem(
            id: id,
            price: price,
            title: title,
            quantity: 1,
          ),
        },
      );
    }
    notifyListeners();
  }

  void subtractFromCart(String id) {
    CartItem product =
        _items.entries.firstWhere((element) => element.key == id).value;

    if (product.quantity <= 1) {
      removeFromCart(product.id);
    } else {
      _items.update(
        id,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: item.quantity - 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productCartId) {
    _items.remove(productCartId);
    notifyListeners();
  }
}
