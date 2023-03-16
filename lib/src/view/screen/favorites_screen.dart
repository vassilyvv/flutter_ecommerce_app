import 'package:e_commerce_flutter/src/controller/catalogue_filter_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../model/catalogue/menu_section.dart';
import '../../model/catalogue/menu_section_entry.dart';
import '../widget/menu_section_entry_grid_view.dart';

enum AppbarActionType { leading, trailing }

final CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());
//
// class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
//   Widget widget;
//   bool fadeOutOnScroll = false;
//
//   PersistentHeaderDelegate(
//       {required this.widget, required this.fadeOutOnScroll});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Column(children: [
//       Flexible(child: SizedBox(height: minExtent - shrinkOffset)),
//       widget
//     ]);
//   }
//
//   @override
//   double get maxExtent => 48;
//
//   @override
//   double get minExtent => 48;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoritesScreenState();
  }
}

class FavoritesScreenState extends State<FavoritesScreen> {
  Widget _gridItemHeader(MenuSectionEntry menuSectionEntry, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: true,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "30% OFF",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: catalogueFilterController
                          .filteredMenuSectionEntries[index].favoriteEntry !=
                      null
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () => catalogueFilterController
                .addMenuSectionEntryToFavorites(menuSectionEntry),
          ),
        ],
      ),
    );
  }

  Widget _gridItemBody(MenuSectionEntry menuSectionEntry) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
      ),
      child: Image.asset(menuSectionEntry.images[0], scale: 1),
    );
  }

  Widget _gridItemFooter(
      MenuSectionEntry menuSectionEntry, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 60,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                menuSectionEntry.offers[0].outcomeTransactionTemplate.entries[0]
                    .asset.translations['en']!['name']!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  menuSectionEntry.offers[0].prices,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // const SizedBox(width: 3),
                // Visibility(
                //   visible: product.off != null ? true : false,
                //   child: Text(
                //     "\$${product.price}",
                //     style: const TextStyle(
                //       decoration: TextDecoration.lineThrough,
                //       color: Colors.grey,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  //
  // Widget _recommendedProductListView(BuildContext context) {
  //   return SizedBox(
  //     height: 170,
  //     child: ListView.builder(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         shrinkWrap: true,
  //         scrollDirection: Axis.horizontal,
  //         itemCount: AppData.recommendedProducts.length,
  //         itemBuilder: (_, index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(right: 20),
  //             child: Container(
  //               width: 300,
  //               decoration: BoxDecoration(
  //                 color: AppData.recommendedProducts[index].cardBackgroundColor,
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 20),
  //                     child: SizedBox(
  //                         width: 130,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               '30% OFF DURING \nCOVID 19',
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .displaySmall
  //                                   ?.copyWith(color: Colors.white),
  //                             ),
  //                             const SizedBox(height: 8),
  //                             ElevatedButton(
  //                               onPressed: () {},
  //                               style: ElevatedButton.styleFrom(
  //                                   backgroundColor: AppData
  //                                       .recommendedProducts[index]
  //                                       .buttonBackgroundColor,
  //                                   elevation: 0,
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 18)),
  //                               child: Text(
  //                                 "Get Now",
  //                                 style: TextStyle(
  //                                   color: AppData.recommendedProducts[index]
  //                                       .buttonTextColor!,
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         )),
  //                   ),
  //                   const Spacer(),
  //                   Image.asset(
  //                     'assets/images/shopping.png',
  //                     height: 125,
  //                     fit: BoxFit.cover,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

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
            child: SingleChildScrollView(child: MenuSectionEntriesGridView(favorites: true))));
  }
}