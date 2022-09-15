import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';
import 'package:shop_shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  bool isShowFavoritesOnly;

  ProductsGrid({this.isShowFavoritesOnly = false});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final List<Product> displayedProducts =
        isShowFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: displayedProducts[i],
        child: ProductItem(),
      ),
      itemCount: displayedProducts.length,
    );
  }
}
