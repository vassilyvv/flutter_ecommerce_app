import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';

final ProductController controller = Get.put(ProductController());

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: ProductGridView(),
      ),
    );
  }
}
