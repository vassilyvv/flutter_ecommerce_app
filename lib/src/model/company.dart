import 'package:collection/collection.dart';

class Company {
  late int id;
  Map<String, Map<String, String>> translations = {};

  Company({required this.id, required this.translations});

  Company.fromJson(json) {
    id = json['id'];
    for (int i = 0; i < json['translations'].length; ++i) {
      translations[json['translations'][i]['language']] = {
        'name': json['translations'][i]['name']
      };
    }
  }

  Map<String, String> translateTo(language) {
    return translations.entries
            .firstWhereOrNull(
                (translation) => translation.key == language.substring(0, 2))
            ?.value ??
        translations.entries
            .firstWhereOrNull((translation) => translation.key == 'en')
            ?.value ??
        translations.values.toList()[0];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
