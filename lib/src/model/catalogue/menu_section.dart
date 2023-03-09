import 'package:e_commerce_flutter/src/model/translatable_model.dart';
import '../company/company.dart';

class MenuSection extends TranslatableModel {
  late Company? company;
  List<MenuSection> children = [];

  MenuSection.fromJson(json) : super.fromJson(json) {
    company =
        json['company'] == null ? null : Company.fromJson(json['company']);
    for (int i = 0; i < json['children'].length; ++i) {
      children.add(MenuSection.fromJson(json['children'][i]));
    }
  }

  @override
  String toString() {
    return 'MenuSection{id: $id, company: $company}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSection &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
