import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/helpers/custom_route.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/providers/cart_provider.dart';
import 'package:shop_shop/providers/orders_provider.dart';
import 'package:shop_shop/providers/products_provider.dart';
import 'package:shop_shop/screens/cart_screen.dart';
import 'package:shop_shop/screens/edit_product_screen.dart';
import 'package:shop_shop/screens/login_screen.dart';
import 'package:shop_shop/screens/manage_product_screen.dart';
import 'package:shop_shop/screens/orders_screen.dart';
import 'package:shop_shop/screens/product_detail_screen.dart';
import 'package:shop_shop/screens/products_overview_screen.dart';
import 'package:shop_shop/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MAIN RUNS');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (context) => OrdersProvider(),
          update: (context, authProvider, previous) =>
              OrdersProvider(token: authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider(),
          update: (context, authProvider, previous) =>
              ProductsProvider(token: authProvider.token),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, value, child) {
          print('AUTH CHANGES TO: ${value.isAuth}');

          return MaterialApp(
            key: Key('auth+${value.isAuth}'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.amber,
              accentColor: Colors.blue,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  TargetPlatform.windows: CustomPageTransitionBuilder(),
                },
              ),
            ),
            home: value.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: value.tryAutoLogin(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen();
                    },
                  ),
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              ProductsOverviewScreen.routeName: (context) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(
                    userId: Provider.of<AuthProvider>(context, listen: false)
                        .userId!,
                  ),
              ManageProductScreen.routeName: (context) => ManageProductScreen(),
            },
          );
        },
      ),
    );
  }
}
