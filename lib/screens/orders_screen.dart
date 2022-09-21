import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'order';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final List<OrderItem> orderList = ordersProvider.orderList;

    return Scaffold(
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
          Container(
            // duration: Duration(milliseconds: 500),
            padding: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 12),
            height: isExpanded ? null : 0,
            width: double.infinity,
            color: Colors.grey[300],
            child: ListView.builder(
              shrinkWrap: true,
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
