import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shop_shop/screens/manage_product_screen.dart';
import 'package:shop_shop/screens/orders_screen.dart';
import 'package:shop_shop/screens/products_overview_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            child: Text('Side Drawer'),
            decoration: BoxDecoration(color: Colors.amber),
          ),
          ListTile(
            title: Text('Product Overview'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushReplacementNamed(
                  context, ProductsOverviewScreen.routeName);
            },
          ),
          ListTile(
            // tileColor: Colors.amber,
            title: Text('Order History'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          ListTile(
            // tileColor: Colors.amber,
            title: Text('Manage Product'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushReplacementNamed(
                  context, ManageProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
