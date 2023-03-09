import 'package:e_commerce_flutter/src/api/client.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:get/get.dart';

import '../model/catalogue/menu_section.dart';
import '../model/catalogue/menu_section_entries_list_entry.dart';
import '../model/catalogue/menu_section_entry.dart';

const String marketplaceId = String.fromEnvironment('apiBaseUrl',
    defaultValue: 'effe47ef-1614-498c-b541-caaff951e7a7');

class CatalogueFilterController extends GetxController with StateMixin {
  Rx<MenuSection?> selectedMenuSection = Rx<MenuSection?>(null);
  RxString searchQuery = "".obs;
  RxList<MenuSectionEntry> filteredMenuSectionEntries =
      <MenuSectionEntry>[].obs;

  Future<void> selectRootMenuSection(String? companyId) async {
    selectedMenuSection.value = (await APIClient()
            .getMarketplaceRootMenuSection(marketplaceId, companyId))
        .menuSection;
    update();
  }

  void selectMenuSection(MenuSection menuSection) {
    selectedMenuSection.value = menuSection;
    _fetchMenuSectionEntriesFromServer(null, menuSection.id, null);
  }

  void showFavorites() {
    _fetchMenuSectionEntriesFromServer(
        "00000000-0000-0000-0000-000000000001", null, null);
  }

  void search(String query) async {
    searchQuery.value = query;
    _fetchMenuSectionEntriesFromServer(null, null, query);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    selectRootMenuSection(null).then((selectedMenuSection) {});
  }

  _fetchMenuSectionEntriesFromServer(String? menuSectionEntriesListId,
      String? menuSectionId, String? searchQuery) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    List<MenuSectionEntry> result = (await APIClient().getMenuSectionEntries(
            accessToken, menuSectionEntriesListId, menuSectionId, searchQuery))
        .menuSectionEntries;
    filteredMenuSectionEntries.assignAll(result);
    update();
  }

  Future<MenuSectionEntriesListEntry?> addMenuSectionEntryToFavorites(
      MenuSectionEntry menuSectionEntry) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    if (accessToken != null) {
      MenuSectionEntriesListEntry? createdEntry = (await APIClient()
              .addMenuSectionEntryToFavorites(accessToken, menuSectionEntry))
          .menuSectionEntriesListEntry;
      if (createdEntry != null) {
        filteredMenuSectionEntries
            .firstWhere(
                (menuSectionEntry) => menuSectionEntry == menuSectionEntry)
            .favoriteEntry = createdEntry;
      }
      update();
      return createdEntry;
    }
    return null;
  }

  Future<bool> removeMenuSectionEntryFromFavorites(
      MenuSectionEntriesListEntry menuSectionEntriesListEntry) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    if (accessToken != null) {
      RemoveMenuSectionEntryFromFavoritesResponse? response = await APIClient()
          .removeFavoritesEntry(accessToken, menuSectionEntriesListEntry);
      if (response != null && response.statusCode < 300) {
        return true;
      }
    }
    return false;
  }
}
