import 'package:e_commerce_flutter/src/model/company.dart';

class Node {
  late int id;
  int? companyId;
  Company? company;
  late String internalId;
  late List<String> fieldValues;
  int? userId;
  List<int> producedAssets = [];
  bool hasWarehouse = false;

  Node.fromJson(json) {
    id = json['id'];
    if (json['company'] is int?) {
      companyId = json['company_id'];
    } else {
      company = json['company'] == null ? null : Company.fromJson(json['company']);
    }
    internalId = json['internal_id'] ?? "";
    userId = json['user_id'];
    fieldValues =
    json['field_values'] == null ? [] : (json['field_values'] as List<dynamic>).map((e) => e.toString()).toList();
    producedAssets = json['producer_marks'] == null
        ? []
        : (json['producer_marks'] as List<dynamic>).map((e) => e['asset'] as int).toList();
    hasWarehouse = json['has_warehouse'] ?? false;
  }

  @override
  String toString() {
    return 'Node{id: $id, companyId: $companyId, company: $company, internalId: $internalId, fieldValues: $fieldValues, userId: $userId, producedAssets: $producedAssets, hasWarehouse: $hasWarehouse}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Node && runtimeType == other.runtimeType && id == other.id && internalId == other.internalId;

  @override
  int get hashCode => id.hashCode ^ internalId.hashCode;
}