import 'package:e_commerce_flutter/src/view/screen/search_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/view/screen/cart_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/profile_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/favorite_screen.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/view/screen/all_product_screen.dart';

final ProductController controller = Get.put(ProductController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Widget> screens = [
    AllProductScreen(),
    SearchScreen(),
    FavoriteScreen(),
    CartScreen(),
    AuthScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          unselectedItemColor:Colors.grey,
          selectedItemColor: Colors.deepOrange,
          items: AppData.bottomNavBarItems
              .map(
                (item) =>
                    BottomNavigationBarItem(icon: item.icon, label: item.title),
              )
              .toList(),
          currentIndex: controller.currentBottomNavItemIndex.value,
          onTap: controller.switchBetweenBottomNavigationItems,
        );
      }),
      body: Obx(() {
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: screens[controller.currentBottomNavItemIndex.value],
        );
      }),
    );
  }
}
