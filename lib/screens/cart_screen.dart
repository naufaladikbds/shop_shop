import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/providers/cart_provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Map<String, CartItem> cartItems = cartProvider.items;
    List<CartItem> cartItemsList = [];

    cartItems.forEach((key, value) => cartItemsList.add(
        value)); // TODO you can also use map.values.toList to get a list of only the values

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        height: double.infinity,
        child: Column(
          children: [
            CartOverview(
              cartProvider: cartProvider,
            ),
            CartList(
              cartItemsList: cartItemsList,
              cartProvider: cartProvider,
            ),
          ],
        ),
      ),
    );
  }
}

class CartOverview extends StatelessWidget {
  const CartOverview({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total: '),
            Row(
              children: [
                // Chip(
                Text(
                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    orderProvider
                        .addToOrder(cartProvider.items.values.toList(),
                            userId: authProvider.userId!)
                        .then((value) {
                      cartProvider.emptyCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order placed successfully'),
                        ),
                      );
                    }).catchError((e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add order: $e'),
                        ),
                      );
                    });
                  },
                  child: const Text('Order'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  final CartProvider cartProvider;
  const CartList({required this.cartItemsList, required this.cartProvider});

  final List<CartItem> cartItemsList;
  final double numberColWidth = 20;
  final int nameColWidth = 25;
  final int priceColWidth = 13;
  final double quantColWidth = 95;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                width: double.infinity,
                child: const Text(
                  'Item List',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, i) => Dismissible(
                    onDismissed: (direction) {
                      switch (direction) {
                        case DismissDirection.startToEnd:
                          cartProvider.removeFromCart(cartItemsList[i].id);
                          break;
                        default:
                          break;
                      }
                    },
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                              'Remove "${cartItemsList[i].title}" from cart?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Nevermind'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                    dismissThresholds: {
                      DismissDirection.startToEnd: 0.9,
                    },
                    background: Container(
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.only(left: 10),
                      color: Color.fromARGB(255, 252, 109, 99),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_forever,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'REMOVE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    key: ValueKey(cartItemsList[i].id),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: numberColWidth,
                              child: Text('${i + 1}. '),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: nameColWidth,
                              child: Text(cartItemsList[i].title),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: priceColWidth,
                              child: Text(
                                '\$${cartItemsList[i].price.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              width: quantColWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Colors.grey[300],
                                    height: 23,
                                    width: 20,
                                    child: IconButton(
                                      onPressed: () =>
                                          cartProvider.subtractFromCart(
                                              cartItemsList[i].id),
                                      icon: Icon(Icons.remove),
                                      padding: EdgeInsets.all(0),
                                      iconSize: 15,
                                      splashRadius: 15,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.grey[100],
                                    height: 23,
                                    width: 35,
                                    child: Text(
                                      'x${cartItemsList[i].quantity}',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[300],
                                    height: 23,
                                    width: 20,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.add),
                                      onPressed: () => cartProvider.addToCart(
                                        cartItemsList[i].id,
                                        cartItemsList[i].title,
                                        cartItemsList[i].price,
                                      ),
                                      iconSize: 13,
                                      splashRadius: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  itemCount: cartItemsList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
