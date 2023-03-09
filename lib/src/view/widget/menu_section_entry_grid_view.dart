import 'package:e_commerce_flutter/src/controller/catalogue_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';

import '../../model/catalogue/menu_section_entry.dart';
import '../../model/trade/offer.dart';

CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());

class MenuSectionEntriesGridView extends StatelessWidget {
  const MenuSectionEntriesGridView({Key? key}) : super(key: key);

  Widget _gridItemHeader(MenuSectionEntry menuSectionEntry, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: false,
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
              color: menuSectionEntry.favoriteEntry != null
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () {
              if (menuSectionEntry.favoriteEntry != null) {
                catalogueFilterController.removeMenuSectionEntryFromFavorites(
                    menuSectionEntry.favoriteEntry!);
              } else {
                catalogueFilterController
                    .addMenuSectionEntryToFavorites(menuSectionEntry);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _gridItemBody(Offer offer) {
    return SizedBox(
        height: 170,
        child: PageView.builder(
            itemCount: offer.images.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                  "http://localhost:8000${offer.images[index]}");
            }));
  }

  Widget _gridItemFooter(Offer offer) {
    return Container(
        margin: const EdgeInsets.all(10),
        //padding: const EdgeInsets.all(20),
        color: Colors.white,
        height: 60,
        width: double.infinity,
        child: FittedBox(
          child: Column(children: [
            Text(
              offer.assetNames.toSet().toList().join(','),
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(offer.prices)
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () {
        return catalogueFilterController.filteredMenuSectionEntries.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(0),
                itemCount:
                    catalogueFilterController.filteredMenuSectionEntries.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 10 / 16,
                    crossAxisCount: size.width ~/ 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (_, index) {
                  MenuSectionEntry menuSectionEntry = catalogueFilterController
                      .filteredMenuSectionEntries[index];
                  return OpenContainerWrapper(
                      menuSectionEntry: menuSectionEntry,
                      child: PageView(
                          children: menuSectionEntry.offers
                              .map((offer) => Column(children: [
                                    _gridItemHeader(menuSectionEntry, index),
                                    _gridItemBody(offer),
                                    const Spacer(),
                                    _gridItemFooter(offer),
                                  ]))
                              .toList()));
                },
              )
            : const Text('no elements');
      },
    );
  }
}
