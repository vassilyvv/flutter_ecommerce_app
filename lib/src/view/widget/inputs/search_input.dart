import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/catalogue_filter_controller.dart';

final CatalogueFilterController controller = Get.put(CatalogueFilterController());

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        controller.search(text);
      },
      onSubmitted: (value) {controller.search(value);},
    );
  }
}