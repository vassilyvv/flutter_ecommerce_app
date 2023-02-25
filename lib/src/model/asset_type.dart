import 'package:collection/collection.dart';

import 'asset_field.dart';


class AssetType {
  late int id;
  late int companyId;
  late List<AssetField> fields;

  AssetType.fromJson(json) {
    id = json['id'];
    companyId = json['company'];
    fields =
    json['fields'] == null ? [] : (json['fields'] as List<dynamic>).map((e) => AssetField.fromJson(e)).toList();
  }

  Map<String, String?> translateTo(language) {
    return fields.firstWhereOrNull((field) => field.useAsVerbose == true)?.translateTo(language) ??
        {'value': ''};
  }

  @override
  String toString() {
    return 'AssetType{id: $id, fields: $fields, companyId: $companyId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AssetType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}