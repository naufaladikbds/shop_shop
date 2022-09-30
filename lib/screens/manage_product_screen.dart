import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';
import 'package:shop_shop/screens/edit_product_screen.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({Key? key}) : super(key: key);

  static const routeName = 'manage-product';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.items;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) => EditProductScreen(),
                );
              },
              icon: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        displacement: 50,
        onRefresh: () {
          productsProvider.clearProducts();
          return productsProvider.fetchProducts();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, i) {
              Product product = products[i];

              return Dismissible(
                onDismissed: (direction) {
                  switch (direction) {
                    case DismissDirection.startToEnd:
                      productsProvider.removeProduct(product.id);
                      break;
                    default:
                      break;
                  }
                },
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                          'Remove product "${product.title}" permanently?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Nevermind'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                background: Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  padding: EdgeInsets.only(left: 10),
                  color: Color.fromARGB(255, 252, 109, 99),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_forever,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'REMOVE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                key: ValueKey(product.id),
                child: Container(
                  height: 60,
                  child: Card(
                    margin:
                        EdgeInsets.only(left: 0, top: 2, bottom: 2, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                width: 1,
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
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
                                isScrollControlled: true,
                                context: context,
                                builder: (ctx) => EditProductScreen(
                                  productId: product.id,
                                  title: product.title,
                                  price: product.price,
                                  description: product.description,
                                  imageUrl: product.imageUrl,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
