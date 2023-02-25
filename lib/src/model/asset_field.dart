import 'package:collection/collection.dart';

class AssetField {
  int? id;
  bool? useAsVerbose;
  bool? required;
  String? regex;
  int? assetTypeId;
  Map<String, String?> translations = {};

  AssetField() {
    id = DateTime.now().millisecondsSinceEpoch;
  }

  AssetField.fromJson(json) {
    id = json['id'];
    useAsVerbose = json['use_as_verbose'] ?? false;
    required = json['required'] ?? false;
    regex = json['regex'];
    assetTypeId = json['asset_type'];
    if (json['translations'] != null) {
      for (int i = 0; i < json['translations'].length; ++i) {
        String? value = json['translations'][i]['value'];
        translations[json['translations'][i]['language']] = value ?? "";
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "use_as_verbose": useAsVerbose,
      "is_required": required,
      "regex": regex,
      "translations": translations,
    };
  }

  Map<String, String?> translateTo(language) {
    return {
      'value':
      translations.entries.firstWhereOrNull((translation) => translation.key == language.substring(0, 2))?.value ??
          '""'
    };
  }

  @override
  String toString() {
    return 'AssetField{id: $id, useAsVerbose: $useAsVerbose, required: $required, regex: $regex, assetTypeId: $assetTypeId, translations: $translations}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AssetField && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}