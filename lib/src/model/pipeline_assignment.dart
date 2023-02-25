class PipelineAssignment {
  late int id;
  int? pipelineId;
  int? previousPipelineId;
  String? transactionId;

  PipelineAssignment.fromJson(json) {
    id = json['id'];
    pipelineId = json['pipeline'];
    previousPipelineId = json['previous'];
    transactionId = json['transaction'];
  }

  @override
  String toString() {
    return 'PipelineAssignment{id: $id, pipelineId: $pipelineId, previousPipelineId: $previousPipelineId, transactionId: $transactionId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PipelineAssignment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}