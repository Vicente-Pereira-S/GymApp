class CompletedWorkoutDay {
  final DateTime date;
  final String routineId;
  final String routineName;

  const CompletedWorkoutDay({
    required this.date,
    required this.routineId,
    required this.routineName,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'routineId': routineId,
      'routineName': routineName,
    };
  }

  factory CompletedWorkoutDay.fromMap(Map<dynamic, dynamic> map) {
    return CompletedWorkoutDay(
      date: DateTime.parse(map['date'] as String),
      routineId: map['routineId'] as String,
      routineName: map['routineName'] as String,
    );
  }
}
