import 'package:collection/collection.dart';

class MenuSection {
  late String? id;
  late String? companyId;
  late String? parent;
  late String? marketplace;
  late List<MenuSection> children;
  Map<String, Map<String, String>> translations = {};

  MenuSection({this.id, this.companyId, this.parent, this.marketplace});

  MenuSection.fromJson(json) {
    id = json['id'];
    companyId = json['company'];
    parent = json['parent'];
    marketplace = json['marketplace'];
    children = json['children'] == null
        ? []
        : (json['children'] as List<dynamic>)
            .map((e) => MenuSection.fromJson(e))
            .toList();
    json['translations']
        .entries
        .toList()
        .forEach((languageToTranslationsEntry) {
      if (!translations.containsKey(languageToTranslationsEntry.key)) {
        translations[languageToTranslationsEntry.key] = {};
        languageToTranslationsEntry.value.entries.forEach((fieldNameToValueEntry) {
          translations[languageToTranslationsEntry.key]![
          fieldNameToValueEntry.key] = fieldNameToValueEntry.value;
        });
      }
    });
  }

  Map<String, String> translateTo(language) {
    return translations.entries
            .firstWhereOrNull(
                (translation) => translation.key == language.substring(0, 2))
            ?.value ??
        {'name': ''};
  }

  @override
  String toString() {
    return 'MenuSection{id: $id, companyId: $companyId, parent: $parent, marketplace: $marketplace, translations: $translations}';
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
