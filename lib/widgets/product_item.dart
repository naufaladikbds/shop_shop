import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/cart_provider.dart';
import 'package:shop_shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product productProvider =
        Provider.of<Product>(context, listen: false);
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Color.fromRGBO(1, 1, 1, 0.8),
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (context, value, child) => Icon(
                productProvider.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Color.fromARGB(255, 255, 144, 212),
              ),
            ),
            onPressed: () {
              productProvider.toggleFavorite().catchError((e) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(content: Text('Network Failure: $e')),
                  );
              });
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              cartProvider.addToCart(
                productProvider.id,
                productProvider.title,
                productProvider.price,
              );

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('${productProvider.title} added to cart'),
                    duration: Duration(milliseconds: 1100),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cartProvider.subtractFromCart(productProvider.id);
                      },
                    ),
                  ),
                );
            },
          ),
          title: Text(
            productProvider.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            ProductDetailScreen.routeName,
            arguments: productProvider.id,
          ),
          child: Image.network(
            productProvider.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
