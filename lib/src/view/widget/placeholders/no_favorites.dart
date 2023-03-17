import 'package:flutter/material.dart';

class NoFavorites extends StatelessWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(size:300, Icons.favorite_border),
        Text(
          "You didn't add any items to favorites yet.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    ));
  }
}
