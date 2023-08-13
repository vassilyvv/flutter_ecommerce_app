import 'package:very_supply_mobile_marketplace_1/src/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:very_supply_api_client/api/client.dart';
import 'package:very_supply_api_client/api/responses.dart';
import 'package:very_supply_api_client/models/catalogue/menu_section.dart';
import 'package:very_supply_api_client/models/catalogue/menu_section_entry.dart';

const String marketplaceId = String.fromEnvironment('marketplaceId',
    defaultValue: '593da4b7-d01f-43e6-bb8b-78f108bc245e');
const String favoritesListId = String.fromEnvironment('favoritesListId',
    defaultValue: '6a1be20c-7f40-4963-b159-9703fb2ddef4');

class CatalogueFilterController extends GetxController with StateMixin {
  Rx<MenuSection?> selectedMenuSection = Rx<MenuSection?>(null);
  RxString searchQuery = "".obs;
  RxList<MenuSectionEntry> filteredMenuSectionEntries =
      <MenuSectionEntry>[].obs;

  Future<void> selectRootMenuSection(String? companyId) async {
    selectedMenuSection.value =
        (await apiMethods['getMarketplaceRootMenuSection']!(
                {'marketplaceId': marketplaceId, 'companyId': companyId}))
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
    search('');
  }

  _fetchMenuSectionEntriesFromServer(String? menuSectionEntriesListId,
      String? menuSectionId, String? searchQuery) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    List<MenuSectionEntry> result =
        (await apiMethods['getMenuSectionEntries']!({
      'accessToken': accessToken,
      'menuSectionEntriesListId': menuSectionEntriesListId,
      'menuSectionId': menuSectionId,
      'searchQuery': searchQuery
    }))
            .menuSectionEntries;
    filteredMenuSectionEntries.assignAll(result);
    update();
  }

  Future<String?> addMenuSectionEntryToFavorites(
      MenuSectionEntry menuSectionEntryToAddToFavorites) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    if (accessToken != null) {
      String? createdEntryId =
          (await apiMethods['addMenuSectionEntryToMenuSectionEntriesList']!({
        'accessToken': accessToken,
        'menuSectionEntryId': menuSectionEntryToAddToFavorites.id,
        'menuSectionEntriesListId': favoritesListId
      }))
              .menuSectionEntriesListEntryId;
      if (createdEntryId != null) {
        filteredMenuSectionEntries
            .firstWhere((menuSectionEntry) =>
                menuSectionEntry == menuSectionEntryToAddToFavorites)
            .favoriteEntry = createdEntryId;
      }
      filteredMenuSectionEntries.refresh();
      return createdEntryId;
    }
    return null;
  }

  Future<bool> removeMenuSectionEntryFromFavorites(
      String menuSectionEntriesListEntryId) async {
    String? accessToken =
        Get.put(AuthController()).authenticatedUser.value?.accessToken;
    if (accessToken != null) {
      RemoveMenuSectionEntryFromFavoritesResponse? response =
          await apiMethods['removeMenuSectionEntryFromMenuSectionEntriesList']!(
              {'accessToken': accessToken, 'menuSectionEntriesListEntryId':menuSectionEntriesListEntryId});
      if (response != null && response.statusCode == 204) {
        filteredMenuSectionEntries
            .firstWhere((menuSectionEntry) =>
                menuSectionEntry.favoriteEntry == menuSectionEntriesListEntryId)
            .favoriteEntry = null;
        filteredMenuSectionEntries.refresh();
        return true;
      }
    }
    return false;
  }
}
