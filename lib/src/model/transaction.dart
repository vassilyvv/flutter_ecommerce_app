
import 'package:e_commerce_flutter/src/model/pipeline_assignment.dart';
import 'package:e_commerce_flutter/src/model/transaction_entry.dart';

class Transaction {
  late String? id;
  int? sourceNode;
  int? targetNode;
  List<TransactionEntry> entries = [];
  int? orderEntry;
  int? orderEntryToPayFor;
  int? orderEntryToCompensateFor;
  List<PipelineAssignment> assignedPipelines = [];

  Transaction.fromJson(json) {
    id = json['id'];
    sourceNode = json['source'];
    targetNode = json['target'];
    entries = json['entries'] == null
        ? []
        : (json['entries'] as List<dynamic>).map((tag) => TransactionEntry.fromJson(tag)).toList();
    orderEntry = json['order_entry'];
    orderEntryToPayFor = json['order_entry_to_pay_for'];
    orderEntryToCompensateFor = json['order_entry_to_compensate_for'];
    assignedPipelines = json['assigned_pipelines'] == null
        ? []
        : (json['assigned_pipelines'] as List<dynamic>).map((tag) => PipelineAssignment.fromJson(tag)).toList();
  }

  @override
  String toString() {
    return 'Transaction{id: $id, sourceNode: $sourceNode, targetNode: $targetNode, entries: $entries, orderEntry: $orderEntry, orderEntryToPayFor: $orderEntryToPayFor, orderEntryToCompensateFor: $orderEntryToCompensateFor, assignedPipelines: $assignedPipelines}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Transaction && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}