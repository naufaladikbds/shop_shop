import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)?.settings.arguments as String;
    Product product = Provider.of<ProductsProvider>(context, listen: false)
        .searchItemById(id);

    return Scaffold(
      // appBar: AppBar(title: Text(product.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              collapseMode: CollapseMode.none,
              background: Hero(
                tag: id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    '\$${product.price}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(product.description),
                ),
                SizedBox(
                  height: 900,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
