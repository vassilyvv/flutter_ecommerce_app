import 'package:collection/collection.dart';

class Site {
  int? id;
  String? domain;
  String? name;

  Site.fromJson(json) {
    id = json['id'];
    domain = json['domain'];
    name = json['name'];
  }

  @override
  String toString() {
    return 'Site{id: $id, domain: $domain, name: $name}';
  }

  String formatString() {
    return [name, domain].whereNotNull().join(": ");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Site && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}