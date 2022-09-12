import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_shop/screens/products_overview_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.blue,
        fontFamily: "Lato",
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
