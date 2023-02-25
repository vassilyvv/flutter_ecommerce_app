import 'offer.dart';

class OrderEntry {
  int? id;
  int? incomeNode;
  int? outcomeNode;
  int? offer;
  int? amount;

  Offer? offerObject;

  OrderEntry() {
    id = DateTime.now().millisecondsSinceEpoch;
  }

  OrderEntry.fromJson(json) {
    id = json['id'];
    incomeNode = json["income_node"]["id"];
    outcomeNode = json["outcome_node"]["id"];
    offer = json['offer'];
    amount = json["amount"];
  }

  Map<String, dynamic> toJson() {
    return {
      'income_node_id': incomeNode,
      'outcome_node_id': outcomeNode,
      'amount': amount,
      'offer_id': offer ?? offerObject?.id,
    };
  }

  @override
  String toString() {
    return 'OrderEntry{id: $id, incomeNode: $incomeNode, outcomeNode: $outcomeNode, offer: $offer, offerObject: $offerObject, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OrderEntry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}