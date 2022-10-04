import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/cart_provider.dart';
import 'package:shop_shop/providers/products_provider.dart';
import 'package:shop_shop/screens/cart_screen.dart';
import 'package:shop_shop/screens/orders_screen.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';
import 'package:shop_shop/widgets/icon_with_badge.dart';
import 'package:shop_shop/widgets/products_grid.dart';

import 'package:http/http.dart' as http;

enum FilterOptions { favorites, all, order }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = 'products-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isShowFavoritesOnly = false;
  bool isInit = false;
  bool isLoading = false;
  late List<Product> productList = [];

  @override
  void didChangeDependencies() {
    print('didChangeDependencies run');
    if (isInit == false) {
      setState(() {
        isLoading = true;
      });
      final productsProvider = Provider.of<ProductsProvider>(context);
      productsProvider
          .fetchProducts()
          .then((_) => productList = productsProvider.items);
      setState(() {
        isLoading = false;
      });
    }
    isInit = true;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Shop Shop'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, value, child) => IconWithBadge(
              badgeCount: value.cartQuantity,
              icon: child as Icon,
              onPress: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
              ),
            ),
            child: const Icon(
              Icons.shopping_cart,
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  isShowFavoritesOnly = true;
                } else if (value == FilterOptions.all) {
                  isShowFavoritesOnly = false;
                } else if (value == FilterOptions.order) {
                  Navigator.pushNamed(context, OrdersScreen.routeName);
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Show favorites only'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show all'),
              ),
              const PopupMenuItem(
                value: FilterOptions.order,
                child: Text('Orders'),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Fetching data...'),
                ],
              ),
            )
          : ProductsGrid(
              isShowFavoritesOnly: isShowFavoritesOnly,
              displayedProducts: productList,
            ),
    );
  }
}
