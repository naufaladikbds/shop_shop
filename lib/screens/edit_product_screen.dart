import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/models/product.dart';
import 'package:shop_shop/providers/products_provider.dart';

import 'package:http/http.dart' as http;
import 'package:shop_shop/widgets/custom_text_form_field.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  final String? productId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final bool isFavorite;

  const EditProductScreen({
    Key? key,
    this.productId,
    this.title = '',
    this.price = 0,
    this.description = '',
    this.imageUrl = '',
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool displayPreview = false;
  bool isLoading = false;

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
    isFavorite: false,
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
        isFavorite: widget.isFavorite,
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

  Future<bool> isImageUrlValid(String url) async {
    final response = await http.head(Uri.parse(editedProduct.imageUrl));
    print('response alt: ${response.statusCode.toString()}');
    final status = response.statusCode.toString();

    if (status == '200') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('login');
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          labelText: 'Title',
                          initialValue: editedProduct.title,
                          validator: (title) {
                            if (title!.trim().isEmpty ||
                                title.trim().length < 3) {
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
                              isFavorite: editedProduct.isFavorite,
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
                              isFavorite: editedProduct.isFavorite,
                            );
                          },
                        ),
                        CustomTextFormField(
                          labelText: 'Description',
                          initialValue: editedProduct.description,
                          focusNode: descFocus,
                          maxLines: 5,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(imageUrlFocus),
                          onSaved: (descInput) {
                            print('test5');
                            editedProduct = Product(
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: descInput ?? '',
                              price: editedProduct.price,
                              imageUrl: editedProduct.imageUrl,
                              isFavorite: editedProduct.isFavorite,
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
                                    isFavorite: editedProduct.isFavorite,
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
                                child:
                                    !displayPreview && widget.productId == null
                                        ? Center(
                                            child: Text(
                                              'Image preview here\n',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          saveForm();
                          bool isValid = true;
                          isImageUrlValid(editedProduct.imageUrl)
                              .then((value) => isValid = value);

                          if (editedProduct.id.isEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            print('start');

                            try {
                              await productProvider.addProduct(
                                id: DateTime.now().toString(),
                                title: editedProduct.title,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                imageUrl: editedProduct.imageUrl.isEmpty ||
                                        !isValid
                                    ? 'https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg'
                                    : editedProduct.imageUrl,
                                isFavorite: false,
                              );
                            } catch (error) {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Okei'),
                                        ),
                                      ],
                                      title: Text('Error'),
                                      content: Text(error.toString()),
                                    );
                                  });
                            } finally {
                              setState(() {
                                isLoading = false;
                                Navigator.pop(context);
                              });
                            }
                          } else {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await productProvider.editProduct(editedProduct);
                            } catch (error) {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Okei'),
                                        ),
                                      ],
                                      title: Text('Error'),
                                      content: Text(error.toString()),
                                    );
                                  });
                            } finally {
                              setState(() {
                                isLoading = false;
                                Navigator.pop(context);
                              });
                            }
                          }
                        }
                      },
                      child: Text(
                        isLoading
                            ? 'loading...'
                            : widget.productId == null
                                ? 'Add Product'
                                : 'Apply Changes',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                width: double.infinity,
                color: Colors.black38,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
