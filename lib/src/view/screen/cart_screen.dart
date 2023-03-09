import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_cart.dart';
import 'package:e_commerce_flutter/src/view/animation/animated_switcher_wrapper.dart';

import '../../controller/cart_controller.dart';


final CartController cartController = Get.put(CartController());

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "My cart",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }

  Widget cartList() {
    return SingleChildScrollView(
        child: Column(
            children: cartController.cart.entries.map((cartEntry) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      cartEntry.key.images[0],
                      width: 100,
                      height: 90,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartEntry.key.outcomeTransactionTemplate.entries[0].asset
                      .translations['en']!['name']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                // Text(
                //   cartController.getCurrentSize(product),
                //   style: TextStyle(
                //     color: Colors.black.withOpacity(0.5),
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                // const SizedBox(height: 5),
                // Text(
                //   cartController.isPriceOff(product)
                //       ? "\$${product.off}"
                //       : "\$${product.price}",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.w900,
                //     fontSize: 23,
                //   ),
                // ),
              ],
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () => cartController.decreaseItem(cartEntry.key),
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                      AnimatedSwitcherWrapper(
                        child: Text(
                          '${cartEntry.value}',
                          key: ValueKey<int>(
                            cartEntry.value,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () => cartController.increaseItem(cartEntry.key),
                        icon: const Icon(Icons.add, color: Color(0xFFEC6813)),
                      ),
                    ])),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  splashRadius: 10.0,
                  onPressed: () => cartController.removeItemFromCart(cartEntry.key),
                  icon: const Icon(Icons.clear, color: Colors.red),
                ))
          ],
        ),
      );
    }).toList()));
  }

  Widget bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          Obx(
            () {
              return AnimatedSwitcherWrapper(
                child: Text(
                  "\$${cartController.totalPrice}",
                  key: ValueKey<int>(cartController.totalPrice.values.toList()[0]),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFEC6813),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget bottomBarButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
          onPressed: cartController.cart.isEmpty ? null : () {},
          child: const Text("Buy Now"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      cartController.cart.isEmpty ? const EmptyCart() : cartList()),
              bottomBarTitle(),
              bottomBarButton()
            ],
          )),
    );
  }
}
