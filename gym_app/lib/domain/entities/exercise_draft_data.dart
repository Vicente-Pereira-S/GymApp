class ExerciseDraftData {
  final int sets;
  final int repsMin;
  final int repsMax;
  final double? weightKg;
  final String permanentNote;

  const ExerciseDraftData({
    required this.sets,
    required this.repsMin,
    required this.repsMax,
    required this.weightKg,
    required this.permanentNote,
  });

  ExerciseDraftData copyWith({
    int? sets,
    int? repsMin,
    int? repsMax,
    double? weightKg,
    String? permanentNote,
  }) {
    return ExerciseDraftData(
      sets: sets ?? this.sets,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      weightKg: weightKg ?? this.weightKg,
      permanentNote: permanentNote ?? this.permanentNote,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sets': sets,
      'repsMin': repsMin,
      'repsMax': repsMax,
      'weightKg': weightKg,
      'permanentNote': permanentNote,
    };
  }

  factory ExerciseDraftData.fromMap(Map<dynamic, dynamic> map) {
    final int oldReps = (map['reps'] as num?)?.toInt() ?? 12;

    return ExerciseDraftData(
      sets: (map['sets'] as num?)?.toInt() ?? 3,
      repsMin: (map['repsMin'] as num?)?.toInt() ?? oldReps,
      repsMax: (map['repsMax'] as num?)?.toInt() ?? oldReps,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      permanentNote: (map['permanentNote'] as String?) ?? '',
    );
  }
}
