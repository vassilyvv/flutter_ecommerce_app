import 'package:e_commerce_flutter/src/controller/catalogue_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/catalogue/menu_section_entry.dart';
import '../../model/trade/offer.dart';

const gridItemHeight = 220.0;
const gridItemWidth = 200.0;
const gridImageHeight = 170.0;
CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());

class MenuSectionEntriesGridView extends StatelessWidget {
  const MenuSectionEntriesGridView({Key? key}) : super(key: key);

  Widget _addToFavoritesButton(MenuSectionEntry menuSectionEntry, int index) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: menuSectionEntry.favoriteEntry != null
            ? Colors.redAccent
            : const Color(0xFFA6A3A0),
      ),
      onPressed: () {
        print(index);
        if (menuSectionEntry.favoriteEntry != null) {
          catalogueFilterController.removeMenuSectionEntryFromFavorites(
              menuSectionEntry.favoriteEntry!);
        } else {
          catalogueFilterController
              .addMenuSectionEntryToFavorites(menuSectionEntry);
        }
      },
    );
  }

  Widget _offerImagesPageView(Offer offer) {
    return SizedBox(
        height: gridImageHeight,
        child: PageView.builder(
            itemCount: offer.images.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  color: Colors.white,
                  child: Image.network(
                      "http://localhost:8000${offer.images[index]}"));
            }));
  }

  Widget _offerFooter(Offer offer) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SizedBox(
            height: gridItemHeight - gridImageHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: Text(
                    offer.prices,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ))
                ]),
                Row(children: [
                  Expanded(
                      child: Text(offer.assetNames.toSet().toList().join(','),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: GoogleFonts.nunitoSans(fontSize: 16)))
                ])
              ]),
            )));
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
                    childAspectRatio: gridItemWidth / gridItemHeight,
                    crossAxisCount: size.width ~/ gridItemWidth,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (_, index) {
                  MenuSectionEntry menuSectionEntry = catalogueFilterController
                      .filteredMenuSectionEntries[index];
                  return GridTile(
                      child: OpenContainerWrapper(
                    menuSectionEntry: menuSectionEntry,
                    child: Stack(children: [
                      PageView(
                          children: menuSectionEntry.offers
                              .map((offer) => Column(children: [
                                    _offerImagesPageView(offer),
                                    _offerFooter(offer)
                                    //Row(children:[_offerFooter(offer), _addToFavoritesButton(menuSectionEntry, index)])
                                  ]))
                              .toList()),
                      Positioned(
                        right: 5,
                        bottom: 7,
                        child: _addToFavoritesButton(menuSectionEntry, index),
                      )
                    ]),
                  ));
                },
              )
            : const Text('no elements');
      },
    );
  }
}
