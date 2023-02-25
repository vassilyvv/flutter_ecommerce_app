import 'package:collection/collection.dart';

import 'asset_type.dart';


class Asset {
  late int? id;
  late String? barcode;
  late AssetType? assetType;
  Map<String, Map<String, String>> translations = {};

  Asset.fromJson(json) {
    id = json['id'];
    barcode = json['barcode'];
    assetType = json['asset_type'] == null ? null : AssetType.fromJson(json['asset_type']);
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
    return 'Asset{id: $id, barcode: $barcode, assetType: $assetType, translations: $translations}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Asset && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}