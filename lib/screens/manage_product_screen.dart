import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';
import 'package:shop_shop/screens/add_product_screen.dart';
import 'package:shop_shop/screens/edit_product_screen.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({Key? key}) : super(key: key);

  static const routeName = 'manage-product';
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => AddProductScreen(),
                );
              },
              icon: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            Product product = products[i];

            return Dismissible(
              background: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                color: Colors.red[500],
                child: Row(
                  children: [
                    Icon(Icons.delete_forever),
                  ],
                ),
              ),
              key: ValueKey(product.id),
              child: Container(
                height: 60,
                child: Card(
                  margin: EdgeInsets.only(left: 0, top: 3, bottom: 3, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: double.infinity,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(product.title),
                            Text(
                              product.price.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 22,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) => EditProductScreen(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // return Card(
            //   margin: EdgeInsets.all(3),
            //   child: ListTile(
            //     trailing: IconButton(
            //       icon: Icon(Icons.edit),
            //       onPressed: () {
            //         showModalBottomSheet(
            //           context: context,
            //           builder: (ctx) => EditProductScreen(),
            //         );
            //       },
            //     ),
            //     tileColor: Colors.green,
            //     contentPadding: EdgeInsets.zero,
            //     leading: Container(
            //       width: 50,
            //       height: double.infinity,
            //       child: Image.network(
            //         product.imageUrl,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     title: Text(product.title),
            //     subtitle: Text(product.price.toStringAsFixed(2)),
            //   ),
            // );
          },
          itemCount: products.length,
        ),
      ),
    );
  }
}
