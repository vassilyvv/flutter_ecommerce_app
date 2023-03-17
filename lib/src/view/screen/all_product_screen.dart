import 'package:e_commerce_flutter/src/controller/catalogue_filter_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../model/catalogue/menu_section.dart';
import '../widget/menu_section_entry_grid_view.dart';

enum AppbarActionType { leading, trailing }

final CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  Widget widget;
  bool fadeOutOnScroll = false;

  PersistentHeaderDelegate(
      {required this.widget, required this.fadeOutOnScroll});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(children: [
      Flexible(child: SizedBox(height: minExtent - shrinkOffset)),
      widget
    ]);
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AllProductsScreenState();
  }
}

class AllProductsScreenState extends State<AllProductScreen> {
  TextEditingController searchQueryController = TextEditingController();

  Widget _menuItem(MenuSection menuSection) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.deepOrange),
        onPressed: () {
          catalogueFilterController.selectMenuSection(menuSection);
        },
        child: Center(
            child: Text(
                style: const TextStyle(color: Colors.deepOrange),
                menuSection.translations['en']!['name']!)));
  }

  Widget _menu() {
    return Obx(() {
      MenuSection? selectedMenuSection =
          catalogueFilterController.selectedMenuSection.value;
      if (selectedMenuSection == null) {
        return const Text("No menu");
      }
      List<MenuSection>? children = selectedMenuSection.children;
      return Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                if (catalogueFilterController
                        .selectedMenuSection.value?.parent !=
                    null)
                  _menuItem(catalogueFilterController
                      .selectedMenuSection.value!.parent!),
                ...children
                    .map((childMenuSection) => Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: _menuItem(childMenuSection),
                        ))
                    .toList()
              ])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: Row(children: [
                    Expanded(
                        child: TextField(
                            controller: searchQueryController,
                            decoration:
                                InputDecoration(labelText: 'search_query'.tr))),
                    ElevatedButton(
                      onPressed: () {
                        catalogueFilterController
                            .search(searchQueryController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Icon(Icons.search),
                    )
                  ])),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: PersistentHeaderDelegate(
                          fadeOutOnScroll: false,
                          widget: Column(children: [
                            Align(
                                alignment: Alignment.centerLeft, child: _menu())
                          ]))),
                  SliverToBoxAdapter(child: Obx(() {
                    return MenuSectionEntriesGridView(
                        menuSectionEntriesToDisplay: catalogueFilterController
                            .filteredMenuSectionEntries.value);
                  }))
                ]))));
  }
}
