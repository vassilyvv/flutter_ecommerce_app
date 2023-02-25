import 'package:collection/collection.dart';

import 'menu_section_entry.dart';

class MenuSection {
  late int? id;
  late int? companyId;
  late int? parent;
  late int? marketplace;
  late List<MenuSectionEntry> entries;
  late List<MenuSection> children;
  Map<String, Map<String, String>> translations = {};

  MenuSection({this.id, this.companyId, this.parent, this.marketplace, this.entries = const []});

  MenuSection.fromJson(json) {
    id = json['id'];
    companyId = json['company'];
    parent = json['parent'];
    marketplace = json['marketplace'];
    entries = json['entries'] == null ? [] : (json['entries'] as List<dynamic>).map((e) => MenuSectionEntry.fromJson(e)).toList();
    children = json['children'] == null ? [] : (json['children'] as List<dynamic>).map((e) => MenuSection.fromJson(e)).toList();
    for (int i = 0; i < json['translations'].length; ++i) {
      translations[json['translations'][i]['language']] = {'name': json['translations'][i]['name']};
    }
  }

  Map<String, String> translateTo(language) {
    return translations.entries.firstWhereOrNull((translation) => translation.key == language.substring(0, 2))?.value ??
        {'name': ''};
  }

  @override
  String toString() {
    return 'MenuSection{id: $id, companyId: $companyId, parent: $parent, marketplace: $marketplace, entries: $entries, translations: $translations}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MenuSection && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}