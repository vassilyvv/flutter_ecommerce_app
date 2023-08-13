import 'package:flutter/material.dart';

class BottomNavBarItem {
  String title;
  Icon icon;
  Color activeColor;
  Color inActiveColor;

  BottomNavBarItem(
      this.title, this.icon, this.activeColor, this.inActiveColor);
}
