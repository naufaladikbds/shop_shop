import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    // String id = ModalRoute.of(context)?.settings.arguments as String;
    String id = 'p3';
    Product product = Provider.of<ProductsProvider>(context, listen: false)
        .searchItemById(id);

    return Scaffold(
      appBar: AppBar(title: Text(product.id)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 290,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
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
                '${product.price}',
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
              child: Text('${product.description}'),
            ),
          ],
        ),
      ),
    );
  }
}
