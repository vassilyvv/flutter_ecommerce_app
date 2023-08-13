import 'package:very_supply_mobile_marketplace_1/src/controller/catalogue_filter_controller.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/widget/placeholders/no_favorites.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:very_supply_api_client/models/catalogue/menu_section_entry.dart';
import '../widget/menu_section_entry_grid_view.dart';

enum AppbarActionType { leading, trailing }

final CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoritesScreenState();
  }
}

class FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  List<MenuSectionEntry> menuSectionEntriesToDisplay =
                      catalogueFilterController.filteredMenuSectionEntries;
                  menuSectionEntriesToDisplay = menuSectionEntriesToDisplay
                      .where((menuSectionEntry) =>
                          menuSectionEntry.favoriteEntry != null)
                      .toList();

                  return menuSectionEntriesToDisplay.isNotEmpty
                      ? SingleChildScrollView(
                          child: MenuSectionEntriesGridView(
                              menuSectionEntriesToDisplay:
                                  menuSectionEntriesToDisplay))
                      : const NoFavorites();
                }))));
  }
}
