import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  final String? productId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;

  const EditProductScreen({
    Key? key,
    this.productId,
    this.title = '',
    this.price = 0,
    this.description = '',
    this.imageUrl = '',
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool displayPreview = false;

  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.productId != null) {
      titleCtrl.text = widget.title;
      priceCtrl.text = widget.price.toString();
      descCtrl.text = widget.description;
      imageCtrl.text = widget.imageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 15,
            ),
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'Title',
                  controller: titleCtrl,
                ),
                CustomTextFormField(
                  labelText: 'Price',
                  controller: priceCtrl,
                ),
                CustomTextFormField(
                  labelText: 'Description',
                  controller: descCtrl,
                ),
                Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        labelText: 'Image URL',
                        withImagePreview: true,
                        controller: imageCtrl,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.preview),
                          onPressed: () {
                            setState(() {
                              displayPreview = true;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.grey[300],
                        ),
                        width: double.infinity,
                        child: !displayPreview && widget.productId == null
                            ? Center(
                                child: Text(
                                  'Image preview here\n',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  imageCtrl.text,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        'Please input a valid URL\n',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.productId != null
                      ? productProvider.editProduct(
                          widget.productId!,
                          titleCtrl.text,
                          double.parse(priceCtrl.text),
                          descCtrl.text,
                          imageCtrl.text,
                        )
                      : productProvider.addProduct(
                          Product(
                            id: widget.productId ?? DateTime.now().toString(),
                            title: titleCtrl.text,
                            description: descCtrl.text,
                            price: double.parse(priceCtrl.text),
                            imageUrl: imageCtrl.text,
                          ),
                        );

                  Navigator.pop(context);
                },
                child: Text(
                  widget.productId == null ? 'Add Product' : 'Apply Changes',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final bool withImagePreview;

  const CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.withImagePreview = false,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: withImagePreview
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: withImagePreview
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
