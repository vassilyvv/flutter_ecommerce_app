import 'package:e_commerce_flutter/src/model/company.dart';
import 'package:e_commerce_flutter/src/model/site.dart';

import 'menu_section.dart';
import 'menu_section_entry.dart';

class Marketplace {
  int? id;
  int? companyId;

  Site? site;
  List<Company>? merchants;
  List<MenuSection>? children;
  List<MenuSectionEntry>? entries;

  Marketplace.fromJson(json) {
    id = json['id'];
    companyId = json['company'];
    site = json['site'] == null ? null : Site.fromJson(json['site']);
    merchants = json['merchants'] == null
        ? null
        : (json['merchants'] as List<dynamic>).map((e) => Company.fromJson(e)).toList();
    children = json['children'] == null
        ? null
        : (json['children'] as List<dynamic>).map((e) => MenuSection.fromJson(e)).toList();
    entries = json['entries'] == null
        ? null
        : (json['entries'] as List<dynamic>).map((e) => MenuSectionEntry.fromJson(e)).toList();
  }

  @override
  String toString() {
    return 'Marketplace{id: $id, companyId: $companyId, ' /*site: $site*/ ', merchants: $merchants, children: $children, entries: $entries}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Marketplace && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
