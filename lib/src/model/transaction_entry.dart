class TransactionEntry {
  String? id;
  int? asset;
  int? amount;

  TransactionEntry({required this.asset, required this.amount});

  TransactionEntry.fromJson(json) {
    id = json['id'];
    asset = json['asset'];
    amount = json["amount"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset': asset,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'TransactionEntry{id: $id, asset: $asset, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TransactionEntry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}