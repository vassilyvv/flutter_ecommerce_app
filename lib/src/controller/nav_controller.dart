import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NavController extends GetxController {
  RxInt currentBottomNavItemIndex = 0.obs;

  void switchBetweenBottomNavigationItems(int index) {
    currentBottomNavItemIndex.value = index;
  }
}
