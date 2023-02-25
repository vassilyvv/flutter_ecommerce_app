import 'dart:io';

import 'package:collection/collection.dart';
import 'package:e_commerce_flutter/src/model/asset.dart';
import 'package:e_commerce_flutter/src/model/node.dart';
import 'package:e_commerce_flutter/src/model/pair.dart';

class Offer {
  late int? id;
  late Node? incomeNode;
  late Node? outcomeNode;
  late List<Pair<Asset?, int?>> incomeEntries;
  late List<Pair<Asset?, int?>> outcomeEntries;

  Offer.fromJson(json) {
    id = json['id'];
    incomeNode = json["income_node"] == null ? null : Node.fromJson(json["income_node"]);
    outcomeNode = json["outcome_node"] == null ? null : Node.fromJson(json["outcome_node"]);
    incomeEntries = (json['income_transaction_template']['entries'] as List<dynamic>)
        .map((pair) {
      if (pair['asset'] != null && pair['amount'] != null) {
        return Pair(Asset.fromJson(pair['asset']), pair['amount'] as int);
      }
      return null;
    })
        .whereNotNull()
        .toList();
    outcomeEntries = (json['outcome_transaction_template']['entries'] as List<dynamic>)
        .map((pair) {
      if (pair['asset'] != null && pair['amount'] != null) {
        return Pair(Asset.fromJson(pair['asset']), pair['amount'] as int);
      }
      return null;
    })
        .whereNotNull()
        .toList();
  }

  @override
  String toString() {
    return 'Offer{id: $id, incomeNode: $incomeNode, outcomeNode: $outcomeNode, incomeEntries: $incomeEntries, outcomeEntries: $outcomeEntries}';
  }

  String formatString() {
    String outcome = outcomeEntries.map((pair) => "${pair.second}x ${pair.first?.translateTo(Platform.localeName)['name']}").join(", ");
    String income = incomeEntries.map((pair) => "${pair.second}x ${pair.first?.translateTo(Platform.localeName)['name']}").join(", ");
    return "$outcome -> $income";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Offer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}