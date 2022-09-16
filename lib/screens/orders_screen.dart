import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "order";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final List<OrderItem> orderList = ordersProvider.orderList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              child: ListView.builder(
                itemBuilder: (ctx, i) => Text("TEST"),
                itemCount: orderList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
