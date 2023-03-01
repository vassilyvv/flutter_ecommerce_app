import 'package:collection/collection.dart';
import 'package:e_commerce_flutter/src/api/client.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../model/menu_section.dart';

const String marketplaceId = String.fromEnvironment('apiBaseUrl',
    defaultValue: 'aaab0f50-db8d-43f1-bf65-a1a865e44821');

class CatalogueMenuController extends GetxController with StateMixin {
  RxList<MenuSection> menuSections = <MenuSection>[].obs;
  RxList<MenuSection> selectedMenuSections = <MenuSection>[].obs;

  Future<MenuSection> selectRootMenuSection(String? companyId) async {
    MenuSection? result = menuSections
        .firstWhereOrNull((menuSection) => menuSection.companyId == companyId);
    if (result == null) {
      result = (await APIClient()
              .getMarketplaceRootMenuSection(marketplaceId, companyId))
          .menuSection;
      menuSections.add(result);
    }
    selectMenuSection(result);
    update();
    return result;
  }

  void selectMenuSection(MenuSection menuSection) {
    selectedMenuSections.removeWhere((selectedMenuSection) =>
        selectedMenuSection.companyId == menuSection.companyId);
    selectedMenuSections.add(menuSection);
    update();
  }

  MenuSection? getSelectedMenuSectionForCompany(String? companyId) {
    return selectedMenuSections.firstWhereOrNull(
        (selectedMenuSection) => selectedMenuSection.companyId == companyId);
  }

  @override
  Future<void> onInit() async {
    selectRootMenuSection(null).then((selectedMenuSection) {});
  }
}
