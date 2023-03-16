import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/core/app_color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/auth_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/nav_controller.dart';
import '../../model/auth/user.dart';
import '../../model/catalogue/asset.dart';
import '../../model/catalogue/menu_section_entry.dart';
import '../../model/trade/offer.dart';

final CartController cartController = Get.put(CartController());
final NavController navController = Get.put(NavController());
final AuthController authController = Get.put(AuthController());

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
  late Offer _selectedOffer;
  int selectedImageIndex = 0;
  int selectedAssetIndex = 0;
  final Map<String, String> _selectedOptions = {};
  Map<String, Set<String>> _dynamicChoices = {};
  late Set<Map<String, String>> _availableFieldCombinations = {};

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _selectedOffer = widget.menuSectionEntry.offers[0];
    _availableFieldCombinations =
        widget.menuSectionEntry.availableFieldCombinations();
    _dynamicChoices =
        _fieldCombinationsToDynamicChoices(_availableFieldCombinations);
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
          initialRating: _selectedOffer.userRating ?? _selectedOffer.rating,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (newRating) {
            User? authenticatedUser = authController.authenticatedUser.value;
            if (authenticatedUser != null) {
              apiClient.rateOffer(authenticatedUser.accessToken!,
                  _selectedOffer.id, newRating.toInt());
            } else {
              print('not authenticated');
            }
          },
        ),
        Text(
          "(4500 Reviews)",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w300),
        )
      ],
    );
  }

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
        navController.switchBetweenBottomNavigationItems(2);
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
        asset.translations['en']!['name']!,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 10),
      Text(asset.translations['en']!['description']!)
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
              _selectedOffer.prices.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            Text(
              "${_selectedOffer.reserve} in stock",
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
        Obx(() {
          return SizedBox(
            width: double.infinity,
            child: cartController.cart.containsKey(_selectedOffer)
                ? _goToCartButton(context)
                : _addToCartButton(context),
          );
        }),
      ],
    );
  }

  Map<String, Set<String>> _fieldCombinationsToDynamicChoices(
      Set<Map<String, String>> availableFieldCombinations) {
    Map<String, Set<String>> result = {};
    for (var fieldSet in availableFieldCombinations) {
      for (var fieldValueEntry
          in fieldSet.entries.where((entry) => entry.key[0] == '#')) {
        if (!result.containsKey(fieldValueEntry.key)) {
          result[fieldValueEntry.key] = {};
        }
        result[fieldValueEntry.key]!.add(fieldValueEntry.value);
      }
    }
    return result;
  }

  Widget _optionsSelect() {
    return Column(
        children: _dynamicChoices.entries
            .map((entry) => Row(
                    children: entry.value.map((e) {
                  bool _isSelected = _selectedOptions[entry.key] == e;
                  Map<String, String> _newOptions = Map.from(_selectedOptions);
                  _newOptions[entry.key] = e;
                  bool _isSelectable = true;
                  Set<Map<String, String>> filteredFieldCombinations =
                      _availableFieldCombinations;
                  _newOptions.forEach((key, value) {
                    filteredFieldCombinations = filteredFieldCombinations
                        .where((fieldCombination) =>
                            fieldCombination[key] == value)
                        .toSet();
                    if (filteredFieldCombinations.isEmpty) {
                      _isSelectable = false;
                    }
                  });
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: _isSelected
                                  ? Colors.deepOrange
                                  : Colors.white,
                              foregroundColor: Colors.deepOrange),
                          onPressed: () {
                            if (_isSelectable) {
                              setState(() {
                                if (_selectedOptions[entry.key] == e) {
                                  _selectedOptions.remove(entry.key);
                                } else {
                                  _selectedOptions[entry.key] = e;
                                  Set<Offer> filteredOffers = widget
                                      .menuSectionEntry
                                      .getFilteredOffers(_selectedOptions);
                                  if (filteredOffers.length == 1) {
                                    _selectedOffer = filteredOffers.first;
                                  }
                                }
                              });
                            }
                          },
                          child: Text(
                            e,
                            style: TextStyle(
                                color: _isSelected
                                    ? Colors.white
                                    : Colors.deepOrange),
                          )));
                }).toList()))
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
      body: Column(children: [
        Expanded(
            child: SizedBox(
                width: width,
                child: PageView.builder(
                    itemCount: _selectedOffer
                        .outcomeTransactionTemplate.entries.length,
                    controller: _assetPageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedAssetIndex = index;
                      });
                    },
                    itemBuilder: (_, index) {
                      return SingleChildScrollView(
                          child: _assetSpecificContent(_selectedOffer
                              .outcomeTransactionTemplate
                              .entries[index]
                              .asset));
                    }))),
        const Spacer(),
        _optionsSelect(),
        _offerSpecificContent(_selectedOffer)
      ]),
    ));
  }
}
