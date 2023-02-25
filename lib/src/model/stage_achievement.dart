class StageAchievement {
  int? id;
  DateTime? createdAt;
  DateTime? confirmedAt;
  int? stageId;
  String? entryId;
  int? createdBy;
  int? confirmedBy;

  StageAchievement({
    required this.id,
    required this.stageId,
    required this.entryId,
    required this.createdAt,
    this.confirmedAt,
    this.createdBy,
    this.confirmedBy,
  });

  StageAchievement.fromJson(json) {
    id = json['id'];
    createdAt = json['created_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(json['created_at']));
    confirmedAt = json['confirmed_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(json['confirmed_at']));
    stageId = json['stage'];
    entryId = json['entry'];
    createdBy = json['created_by'];
    confirmedBy = json['confirmed_by'];
  }

  @override
  String toString() {
    return 'StageAchievement{id: $id, createdAt: $createdAt, confirmedAt: $confirmedAt, stageId: $stageId, entryId: $entryId, createdBy: $createdBy, confirmedBy: $confirmedBy}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageAchievement && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}