import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'order';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final List<OrderItem> orderList = ordersProvider.orderList;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                OrderItem order = orderList[i];
                return OrderCard(order: order);
              },
              itemCount: orderList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderItem order;

  const OrderCard({
    required this.order,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.totalPrice.toStringAsFixed(2)}',
            ),
            subtitle: Text(
              DateFormat.yMMMMEEEEd().format(widget.order.orderDate),
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.linearToEaseOut,
            padding: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
            height: isExpanded
                ? min(widget.order.orderList.length * 17.5 + 20,
                    180) // dynamic height
                : 0,
            width: double.infinity,
            color: Colors.grey[200],
            child: ListView.builder(
              itemBuilder: (ctx, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.order.orderList[i].title),
                  Text('x${widget.order.orderList[i].quantity}'),
                  Text(widget.order.orderList[i].price.toStringAsFixed(2)),
                ],
              ),
              itemCount: widget.order.orderList.length,
            ),
          ),
        ],
      ),
    );
  }
}
