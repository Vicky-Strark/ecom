import 'package:ecom/Features/cart/model/cart_model.dart';
import 'package:ecom/Features/products/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_ui/hive_ui.dart';

class HiveUI extends StatelessWidget {
  const HiveUI({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HiveBody()),
        );
      },
      icon: Icon(Icons.data_array),
    );
  }
}

class HiveBody extends StatelessWidget {
  const HiveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive Database Viewer')),
      body: HiveBoxesView(
        hiveBoxes: {
          // Use dynamic boxes directly without type casting
          Hive.box('productsBox'): (val) {
            print('Product data: $val');
            return val; // Return as-is, let hive_ui handle display
          },
          Hive.box('cartBox'): (val) {
            print('Cart data: $val');
            return val; // Return as-is, let hive_ui handle display
          },
        },
        onError: (e) {
          print('Hive UI Error: $e');
        },
      ),
    );
  }
}

class Boxes {
  static Box<dynamic> getProductsBox() => Hive.box('productsBox');
  static Box<dynamic> getCartBox() => Hive.box('cartBox');

  static clearBoxes() async {
    await getProductsBox().clear();
    await getCartBox().clear();
  }
}