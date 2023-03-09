import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/core/app_color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/cart_controller.dart';
import '../../model/catalogue/asset.dart';
import '../../model/catalogue/menu_section_entry.dart';
import '../../model/trade/offer.dart';

final CartController cartController = Get.put(CartController());

class MenuSectionEntryDetailScreen extends StatefulWidget {
  const MenuSectionEntryDetailScreen(
      {super.key, required this.menuSectionEntry});

  final MenuSectionEntry menuSectionEntry;

  @override
  State<StatefulWidget> createState() {
    return MenuSectionEntryDetailScreenState();
  }
}

class MenuSectionEntryDetailScreenState
    extends State<MenuSectionEntryDetailScreen> {
  final PageController _assetImagePageController =
      PageController(initialPage: 0);
  final PageController _assetPageController = PageController(initialPage: 0);
  late Offer selectedOffer;
  int selectedImageIndex = 0;
  int selectedAssetIndex = 0;

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    selectedOffer = widget.menuSectionEntry.offers[0];
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          _goBack(context);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget assetImagesPageView(Asset asset, double width, double height) {
    return Container(
      height: height * 0.3,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            itemCount: asset.images.length,
            controller: _assetImagePageController,
            onPageChanged: (index) {
              setState(() {
                selectedImageIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return FittedBox(
                child: Image.network(
                    height: height * 0.11,
                    fit: BoxFit.fitWidth,
                    'http://localhost:8000${asset.images[index]}'),
              );
            },
          ),
          Positioned(
              bottom: 0,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: SmoothPageIndicator(
                    effect: const WormEffect(
                      dotColor: Colors.white,
                      activeDotColor: AppColor.darkOrange,
                    ),
                    controller: _assetImagePageController,
                    count: asset.images.length,
                  )))
        ],
      ),
    );
  }

  Widget _ratingBar(BuildContext context) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: 4.5,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
        ),
        Text(
          "(4500 Reviews)",
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.w300),
        )
      ],
    );
  }

  // Widget menuSectionEntrySizesListView() {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: controller.sizeType(menuSectionEntry).length,
  //     itemBuilder: (_, index) {
  //       return InkWell(
  //         onTap: () => controller.switchBetweenMenuSectionEntrySizes(
  //             menuSectionEntry, index),
  //         child: Container(
  //           margin: const EdgeInsets.only(right: 5, left: 5),
  //           alignment: Alignment.center,
  //           width: controller.isNominal(menuSectionEntry) ? 40 : 70,
  //           decoration: BoxDecoration(
  //             color: controller.sizeType(menuSectionEntry)[index].isSelected ==
  //                     false
  //                 ? Colors.white
  //                 : AppColor.lightOrange,
  //             borderRadius: BorderRadius.circular(10),
  //             border: Border.all(color: Colors.grey, width: 0.4),
  //           ),
  //           child: FittedBox(
  //             child: Text(
  //               controller.sizeType(menuSectionEntry)[index].numerical,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  MaterialButton _addToCartButton(BuildContext context) {
    return MaterialButton(
      color: Colors.deepOrange,
      textColor: Colors.white,
      onPressed: () =>
          cartController.addItemToCart(widget.menuSectionEntry.offers[0]),
      child: const Text("Add to cart"),
    );
  }

  MaterialButton _goToCartButton(BuildContext context) {
    return MaterialButton(
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () {
        _goBack(context);
      },
      child: const Text("Go to cart"),
    );
  }

  Widget _assetSpecificContent(Asset asset) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(children: [
      assetImagesPageView(asset, width, height),
      const SizedBox(height: 10),
      Text(
        "About",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 10),
      Text(asset.translations['en']!['name']!)
    ]);
  }

  Widget _offerSpecificContent(Offer offer) {
    return Column(
      children: [
        _ratingBar(context),
        const SizedBox(height: 30),
        Row(
          children: [
            Text(
              selectedOffer.prices.toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const Spacer(),
            const Text(
              "Available in stock",
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
        Obx(() {
          return SizedBox(
            width: double.infinity,
            child: cartController.cart.containsKey(selectedOffer)
                ? _goToCartButton(context)
                : _addToCartButton(context),
          );
        }),
      ],
    );
  }

  Map<String, Set<String>> _dynamicChoices() {
    Map<String, Set<String>> result = {};
    for (var fieldSet in widget.menuSectionEntry.availableFieldCombinations()) {
      for (var fieldValueEntry in fieldSet.entries) {
        if (!result.containsKey(fieldValueEntry.key)) {
          result[fieldValueEntry.key] = {};
        }
        result[fieldValueEntry.key]!.add(fieldValueEntry.value);
      }
    }
    return result;
  }

  Widget _dynamicChoicesSelect() {
    return Column(
        children: _dynamicChoices()
            .entries
            .map((entry) => Row(
                children: entry.value
                    .map(
                        (e) => MaterialButton(onPressed: () {}, child: Text(e)))
                    .toList()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _appBar(context),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: height * 0.42,
                        width: width,
                        child: PageView.builder(
                            itemCount: selectedOffer
                                .outcomeTransactionTemplate.entries.length,
                            controller: _assetPageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedAssetIndex = index;
                              });
                            },
                            itemBuilder: (_, index) {
                              return _assetSpecificContent(selectedOffer
                                  .outcomeTransactionTemplate
                                  .entries[index]
                                  .asset);
                            })),
                    _dynamicChoicesSelect(),
                    _offerSpecificContent(selectedOffer)
                  ]),
            )));
  }
}
