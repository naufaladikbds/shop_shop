import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = 'edit-product';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Edit Product'),
    );
  }
}
