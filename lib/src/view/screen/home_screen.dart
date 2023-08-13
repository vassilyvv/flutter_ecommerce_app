import 'package:very_supply_mobile_marketplace_1/src/controller/auth_controller.dart';
import 'package:very_supply_mobile_marketplace_1/src/controller/catalogue_filter_controller.dart';
import 'package:very_supply_mobile_marketplace_1/src/controller/nav_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/screen/cart_screen.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/screen/profile_screen.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/screen/all_product_screen.dart';

import '../../../core/app_data.dart';
import 'favorites_screen.dart';

final NavController navController = Get.put(NavController());
final CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());
final AuthController authController = Get.put(AuthController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Widget> screens = [
    AllProductScreen(),
    FavoritesScreen(),
    CartScreen(),
    AuthScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.deepOrange,
          items: AppData.bottomNavBarItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                ),
              )
              .toList(),
          currentIndex: navController.currentBottomNavItemIndex.value,
          onTap: (index) {navController.switchBetweenBottomNavigationItems(index);
            if (index == 0) {
              catalogueFilterController.search('');
            }},
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
          child: screens[navController.currentBottomNavItemIndex.value],
        );
      }),
    );
  }
}
