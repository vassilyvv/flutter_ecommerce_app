import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(size:300, Icons.shopping_cart_outlined),
        Text(
          "Cart is empty. It's time to fill it!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    ));
  }
}
