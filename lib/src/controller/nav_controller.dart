import 'package:e_commerce_flutter/src/view/screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'auth_controller.dart';


final AuthController catalogueFilterController =
Get.put(AuthController());
class NavController extends GetxController {
  RxInt currentBottomNavItemIndex = 0.obs;

  void switchBetweenBottomNavigationItems(int index) {
    if (authController.authenticatedUser.value?.accessToken == null && index == 1) {
      index = 3;
    }
    currentBottomNavItemIndex.value = index;
  }
}
