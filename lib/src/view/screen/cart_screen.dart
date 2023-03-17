import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/view/widget/placeholders/empty_cart.dart';
import 'package:e_commerce_flutter/src/view/animation/animated_switcher_wrapper.dart';

import '../../controller/cart_controller.dart';

final CartController cartController = Get.put(CartController());

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  //
  // PreferredSizeWidget _appBar(BuildContext context) {
  //   return AppBar(
  //     title: Text(
  //       "My cart",
  //       style: Theme.of(context).textTheme.displaySmall,
  //     ),
  //   );
  // }

  Widget cartList() {
    return SingleChildScrollView(
        child: Column(
            children: cartController.cart.entries.map((cartEntry) {
      return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200]?.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Container(
              margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.network(
                    'http://localhost:8000${cartEntry.key.images[0]}',
                    width: 90,
                    height: 90)),
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

                const SizedBox(
                  height: 10,
                ),
                Row(children: [
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
                              onPressed: () =>
                                  cartController.decreaseItem(cartEntry.key),
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
                              onPressed: () =>
                                  cartController.increaseItem(cartEntry.key),
                              icon: const Icon(Icons.add,
                                  color: Color(0xFFEC6813)),
                            ),
                          ])),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        splashRadius: 10.0,
                        onPressed: () =>
                            cartController.removeItemFromCart(cartEntry.key),
                        icon: const Icon(Icons.clear, color: Colors.red),
                      ))
                ])
              ],
            )
          ]));
    }).toList()));
  }

  Widget bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          Obx(
            () {
              return Column(
                  children: cartController.totalPrice.values
                      .map((value) => AnimatedSwitcherWrapper(
                              child: Text(
                            "\$$value",
                            key: ValueKey<int>(value),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFEC6813),
                            ),
                          )))
                      .toList());
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
        padding: const EdgeInsets.only(bottom: 20),
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
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: cartController.cart.isEmpty
                              ? const EmptyCart()
                              : cartList()),
                      if (cartController.cart.isNotEmpty) bottomBarTitle(),
                      if (cartController.cart.isNotEmpty) bottomBarButton()
                    ],
                  )))),
    );
  }
}
