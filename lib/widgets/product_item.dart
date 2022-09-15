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
          backgroundColor: Colors.black54,
          leading: IconButton(
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
            },
          ),
          trailing: IconButton(
            icon: Consumer<Product>(
              builder: (context, value, child) => Icon(
                productProvider.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: productProvider.toggleFavorite,
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
