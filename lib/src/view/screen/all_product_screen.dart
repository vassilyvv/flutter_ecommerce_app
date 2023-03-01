import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/controller/catalogue_menu_controller.dart';

import '../../model/menu_section.dart';
import '../../model/product.dart';
import '../widget/product_grid_view.dart';
import 'dart:math';

enum AppbarActionType { leading, trailing }

final ProductController productController = Get.put(ProductController());
final CatalogueMenuController menuController =
    Get.put(CatalogueMenuController());

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
  Widget _gridItemHeader(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: productController.isPriceOff(product),
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
              color: productController.filteredProducts[index].isLiked
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () => productController.isLiked(index),
          ),
        ],
      ),
    );
  }

  Widget _gridItemBody(Product product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
      ),
      child: Image.asset(product.images[0], scale: 1),
    );
  }

  Widget _gridItemFooter(Product product, BuildContext context) {
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
                product.name,
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
                  product.off != null
                      ? "\$${product.off}"
                      : "\$${product.price}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 3),
                Visibility(
                  visible: product.off != null ? true : false,
                  child: Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _recommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: AppData.recommendedProducts.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppData.recommendedProducts[index].cardBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '30% OFF DURING \nCOVID 19',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppData
                                        .recommendedProducts[index]
                                        .buttonBackgroundColor,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18)),
                                child: Text(
                                  "Get Now",
                                  style: TextStyle(
                                    color: AppData.recommendedProducts[index]
                                        .buttonTextColor!,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/shopping.png',
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _menuItem(MenuSection menuSection) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.red)))),
        onPressed: () {
          menuController.selectMenuSection(menuSection);
        },
        child: Text(menuSection.translateTo('en')['name']!));
  }

  Widget _menu() {
    return Obx(() {
      List<MenuSection>? children =
          menuController.getSelectedMenuSectionForCompany(null)?.children;
      children ??= [];
      return Container(
          color: Colors.white,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: children
                      .map((childMenuSection) => Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: _menuItem(childMenuSection),
                          ))
                      .toList())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Column(children: const [
            Text(style: TextStyle(color: Colors.black), 'Превед педрило'),
        Text(style: TextStyle(color: Colors.black), 'Превед педрило'),
        Text(style: TextStyle(color: Colors.black), 'Превед педрило'),
        ])),
      SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeaderDelegate(
              fadeOutOnScroll: false, widget: Column(children: [_menu()]))),
      const SliverToBoxAdapter(child: ProductGridView())
    ])));
  }
}
