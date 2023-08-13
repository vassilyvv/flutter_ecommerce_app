import 'package:very_supply_mobile_marketplace_1/src/controller/catalogue_filter_controller.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:very_supply_mobile_marketplace_1/src/view/animation/open_container_wrapper.dart';
import 'package:very_supply_api_client/models/catalogue/menu_section_entry.dart';
import 'package:very_supply_api_client/models/trade/offer.dart';


const gridItemWidth = 200.0;
const gridItemHeight = 220.0;
const gridImageHeight = 160.0;

CatalogueFilterController catalogueFilterController =
    Get.put(CatalogueFilterController());

class MenuSectionEntriesGridView extends StatelessWidget {
  const MenuSectionEntriesGridView(
      {Key? key, required this.menuSectionEntriesToDisplay})
      : super(key: key);
  final List<MenuSectionEntry> menuSectionEntriesToDisplay;

  Widget _addToFavoritesButton(MenuSectionEntry menuSectionEntry) {
    return IconButton(
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
                  child: Image.network(offer.images[index]));
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
                  ))
                ]),
                Row(children: [
                  Expanded(
                      child: Text(offer.assetNames.toSet().toList().join(','),
                          textAlign: TextAlign.left, maxLines: 1))
                ])
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: menuSectionEntriesToDisplay.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: gridItemWidth / gridItemHeight,
          crossAxisCount: size.width ~/ gridItemWidth,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (_, index) {
        MenuSectionEntry menuSectionEntry = menuSectionEntriesToDisplay[index];
        return GridTile(
            child: OpenContainerWrapper(
          menuSectionEntry: menuSectionEntry,
          child: Stack(children: [
            PageView(
                children: menuSectionEntry.offers
                    .map((offer) => Column(children: [
                          _offerImagesPageView(offer),
                          Expanded(child: _offerFooter(offer))
                          //Row(children:[_offerFooter(offer), _addToFavoritesButton(menuSectionEntry, index)])
                        ]))
                    .toList()),
            if (authController.authenticatedUser.value?.accessToken != null)
              Positioned(
                right: 5,
                bottom: 7,
                child: _addToFavoritesButton(menuSectionEntry),
              )
          ]),
        ));
      },
    );
  }
}
