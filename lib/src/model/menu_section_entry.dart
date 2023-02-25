import 'offer.dart';

class MenuSectionEntry {
  late int? id;
  late Offer offer;
  late int? menuSectionId;

  MenuSectionEntry.fromJson(json) {
    id = json['id'];
    offer = Offer.fromJson(json['offer']);
    menuSectionId = json['menu_section']['id'];
  }

  @override
  String toString() {
    return 'MenuSectionEntry{id: $id, offer: $offer, menuSectionId: $menuSectionId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSectionEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
