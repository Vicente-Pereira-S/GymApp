class ExerciseWeightEntry {
  final DateTime date;
  final String exerciseId;
  final double weightKg;

  const ExerciseWeightEntry({
    required this.date,
    required this.exerciseId,
    required this.weightKg,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'exerciseId': exerciseId,
      'weightKg': weightKg,
    };
  }

  factory ExerciseWeightEntry.fromMap(Map<dynamic, dynamic> map) {
    return ExerciseWeightEntry(
      date: DateTime.parse(map['date'] as String),
      exerciseId: map['exerciseId'] as String,
      weightKg: (map['weightKg'] as num).toDouble(),
    );
  }
}
