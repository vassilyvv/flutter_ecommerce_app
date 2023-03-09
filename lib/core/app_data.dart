import 'package:e_commerce_flutter/src/model/bottom_nav_bar_item.dart';
import 'package:flutter/material.dart';

class AppData {
  static List<BottomNavBarItem> bottomNavBarItems = [
    BottomNavBarItem(
      "Home",
      const Icon(Icons.home),
      const Color(0xFFEC6813),
      Colors.grey,
    ),
    BottomNavBarItem(
      "Cart",
      const Icon(Icons.shopping_cart),
      const Color(0xFFEC6813),
      Colors.grey,
    ),
    BottomNavBarItem(
      "Profile",
      const Icon(Icons.person),
      const Color(0xFFEC6813),
      Colors.grey,
    ),
  ];
}
