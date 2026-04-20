class Exercise {
  final String id;
  final String routineId;
  final String name;
  final String assetPath;
  final String permanentNote;
  final int defaultSets;
  final int defaultReps;
  final int orderIndex;

  const Exercise({
    required this.id,
    required this.routineId,
    required this.name,
    required this.assetPath,
    required this.permanentNote,
    required this.defaultSets,
    required this.defaultReps,
    required this.orderIndex,
  });

  Exercise copyWith({
    String? name,
    String? assetPath,
    String? permanentNote,
    int? defaultSets,
    int? defaultReps,
    int? orderIndex,
  }) {
    return Exercise(
      id: id,
      routineId: routineId,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      permanentNote: permanentNote ?? this.permanentNote,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
