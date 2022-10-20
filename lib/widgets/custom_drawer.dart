import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/screens/login_screen.dart';
import 'package:shop_shop/screens/manage_product_screen.dart';
import 'package:shop_shop/screens/orders_screen.dart';
import 'package:shop_shop/screens/products_overview_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            otherAccountsPictures: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              authProvider.logout();
                            },
                            child: Text('Logout'),
                          ),
                        ],
                        title: Text('Confirm Logout'),
                        content: Text(
                            'Would you like to sign out from this account?'),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            ],
            accountName: Text(
              'Naufal Adi',
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
            accountEmail: Text(
              'naufaladi1000@gmail.com',
              style: TextStyle(
                color: Colors.grey[200],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/originals/c4/1a/1c/c41a1cc247ec00baab6e163d032f879d.jpg'),
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[900]!,
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(
                    'https://i.kym-cdn.com/photos/images/original/001/285/680/e17.jpg'),
              ),
            ),
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
