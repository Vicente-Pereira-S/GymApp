class ExerciseDraftData {
  final int sets;
  final int reps;
  final double? weightKg;
  final String permanentNote;

  const ExerciseDraftData({
    required this.sets,
    required this.reps,
    required this.weightKg,
    required this.permanentNote,
  });

  ExerciseDraftData copyWith({
    int? sets,
    int? reps,
    double? weightKg,
    String? permanentNote,
  }) {
    return ExerciseDraftData(
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      permanentNote: permanentNote ?? this.permanentNote,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sets': sets,
      'reps': reps,
      'weightKg': weightKg,
      'permanentNote': permanentNote,
    };
  }

  factory ExerciseDraftData.fromMap(Map<dynamic, dynamic> map) {
    return ExerciseDraftData(
      sets: (map['sets'] as num?)?.toInt() ?? 0,
      reps: (map['reps'] as num?)?.toInt() ?? 0,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      permanentNote: (map['permanentNote'] as String?) ?? '',
    );
  }
}
