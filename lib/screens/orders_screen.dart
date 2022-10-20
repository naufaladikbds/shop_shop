import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';
import 'package:shop_shop/screens/login_screen.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchOrders(userId: authProvider.userId),
        builder: (context, snapshot) {
          return Consumer<OrdersProvider>(
            builder: (context, value, child) {
              return RefreshIndicator(
                onRefresh: () =>
                    value.fetchOrders(userId: authProvider.userId!),
                child: value.hasError
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 50,
                            left: 40,
                            right: 40,
                          ),
                          height: MediaQuery.of(context).size.height - 200,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                CircularProgressIndicator(),
                              if (value.hasError) ...[
                                Text(snapshot.error.toString()),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: snapshot.error
                                          .toString()
                                          .contains('expire')
                                      ? () {
                                          Navigator.pushReplacementNamed(
                                              context, LoginScreen.routeName);
                                        }
                                      : () {
                                          value.fetchOrders(
                                              userId: authProvider.userId!);
                                        },
                                  child: Text('Refresh'),
                                ),
                              ]
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (ctx, i) {
                                OrderItem order = value.orderList[i];
                                return OrderCard(order: order);
                              },
                              itemCount: value.orderList.length,
                            ),
                          ),
                        ],
                      ),
              );
            },
          );
        },
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
