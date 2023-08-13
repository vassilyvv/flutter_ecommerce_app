import 'dart:ui';
import 'package:very_supply_mobile_marketplace_1/src/view/translations.dart';
import 'package:flutter/material.dart';
import 'package:very_supply_mobile_marketplace_1/core/app_theme.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/screen/home_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en', 'US'),
      translations: AppTranslations(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: AppTheme.lightAppTheme,
    );
  }
}
