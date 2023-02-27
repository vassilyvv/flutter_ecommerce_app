import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:e_commerce_flutter/src/view/screen/all_product_screen.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({Key? key}) : super(key: key);

  Widget _gridItemHeader(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: productController.isPriceOff(product),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "30% OFF",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: productController.filteredProducts[index].isLiked
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () => productController.isLiked(index),
          ),
        ],
      ),
    );
  }

  Widget _gridItemBody(Product product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color:  Color(0xFFE5E6E8),
      ),
      child: Image.asset(product.images[0], scale: 1),
    );
  }

  Widget _gridItemFooter(Product product, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  product.off != null
                      ? "\$${product.off}"
                      : "\$${product.price}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 3),
                Visibility(
                  visible: product.off != null ? true : false,
                  child: Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: productController.filteredProducts.isNotEmpty
              ? GridView.builder(
                  itemCount: productController.filteredProducts.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 10 / 16,
                    crossAxisCount: size.width ~/ 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10
                  ),
                  itemBuilder: (_, index) {
                    Product product = productController.filteredProducts[index];
                    return OpenContainerWrapper(
                      product: product,
                      child: GridTile(
                        header: _gridItemHeader(product, index),
                        footer: _gridItemFooter(product, context),
                        child: _gridItemBody(product),
                      ),
                    );
                  },
                )
              : Text('no elements'),
        );
      },
    );
  }
}
