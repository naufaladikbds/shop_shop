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

  // final titleCtrl = TextEditingController();
  // final priceCtrl = TextEditingController();
  // final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  final priceFocus = FocusNode();
  final descFocus = FocusNode();
  final imageUrlFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  Product editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    if (widget.productId != null) {
      // titleCtrl.text = widget.title;
      // priceCtrl.text = widget.price.toString();
      // descCtrl.text = widget.description;

      editedProduct = Product(
        id: widget.productId!,
        title: widget.title,
        description: widget.description,
        price: widget.price,
        imageUrl: widget.imageUrl,
      );
      imageCtrl.text = widget.imageUrl;
    }
    super.initState();
  }

  @override
  void dispose() {
    descFocus.dispose();
    priceFocus.dispose();
    imageUrlFocus.dispose();
    super.dispose();
  }

  void saveForm() {
    formKey.currentState!.save();
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              child: Form(
                // onChanged: () {},
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: 'Title',
                      initialValue: editedProduct.title,
                      validator: (title) {
                        if (title!.trim().isEmpty || title.trim().length < 3) {
                          return 'Title must contain 3 characters or more';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFocus);
                      },
                      onSaved: (titleInput) {
                        print('test3');
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: titleInput ?? '',
                          description: editedProduct.description,
                          price: editedProduct.price,
                          imageUrl: editedProduct.imageUrl,
                        );
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Price',
                      initialValue: editedProduct.price == 0
                          ? null
                          : editedProduct.price.toString(),
                      focusNode: priceFocus,
                      validator: (price) {
                        if (price!.contains(RegExp(r'[^0-9.]'))) {
                          return 'Price must only contain numerics [0-9]';
                        }

                        if (price.isEmpty || double.parse(price) < 0.1) {
                          return 'Price can\'t be empty or zero';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(descFocus),
                      onSaved: (priceInput) {
                        print('test4');
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          price: double.parse(
                              priceInput!.isEmpty ? '0.0' : priceInput),
                          imageUrl: editedProduct.imageUrl,
                        );
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Description',
                      initialValue: editedProduct.description,
                      focusNode: descFocus,
                      maxLines: 5,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(imageUrlFocus),
                      onSaved: (descInput) {
                        print('test5');
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: descInput ?? '',
                          price: editedProduct.price,
                          imageUrl: editedProduct.imageUrl,
                        );
                      },
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
                            onSaved: (imageInput) {
                              editedProduct = Product(
                                id: editedProduct.id,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                imageUrl: imageInput ?? '',
                              );
                            },
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                            fit: BoxFit.fill,
                                            'https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg');
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
                    if (formKey.currentState!.validate()) {
                      saveForm();
                      editedProduct.id.isEmpty
                          ? productProvider.addProduct(
                              id: DateTime.now().toString(),
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: editedProduct.price,
                              imageUrl: editedProduct.imageUrl.isEmpty
                                  ? 'https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg'
                                  : editedProduct.imageUrl,
                            )
                          : productProvider.editProduct(
                              editedProduct,
                            );
                      Navigator.pop(context);
                    }
                    // widget.productId != null
                    //     ? productProvider.editProduct(
                    //         widget.productId!,
                    //         titleCtrl.text,
                    //         double.parse(priceCtrl.text),
                    //         descCtrl.text,
                    //         imageCtrl.text,
                    //       )
                    //     : productProvider.addProduct(
                    //         Product(
                    //           id: DateTime.now().toString(),
                    //           title: titleCtrl.text,
                    //           description: descCtrl.text,
                    //           price: double.parse(priceCtrl.text),
                    //           imageUrl: imageCtrl.text,
                    //         ),
                    //       );
                  },
                  child: Text(
                    widget.productId == null ? 'Add Product' : 'Apply Changes',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool withImagePreview;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int maxLines;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.controller,
    this.withImagePreview = false,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.onSaved,
    this.focusNode,
    this.maxLines = 1,
    this.initialValue,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        validator: validator,
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: maxLines,
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
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
