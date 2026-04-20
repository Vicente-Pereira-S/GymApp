import 'package:gym_app/domain/entities/completed_workout_day.dart';
import 'package:gym_app/domain/entities/exercise_draft_data.dart';
import 'package:gym_app/domain/entities/exercise_weight_entry.dart';

class WorkoutState {
  final Map<String, Set<String>> completedExerciseIdsByRoutine;
  final Map<String, ExerciseDraftData> exerciseDrafts;
  final List<CompletedWorkoutDay> completedWorkoutDays;
  final Map<String, List<ExerciseWeightEntry>> weightHistoryByExercise;

  const WorkoutState({
    required this.completedExerciseIdsByRoutine,
    required this.exerciseDrafts,
    required this.completedWorkoutDays,
    required this.weightHistoryByExercise,
  });

  factory WorkoutState.initial() {
    return const WorkoutState(
      completedExerciseIdsByRoutine: {},
      exerciseDrafts: {},
      completedWorkoutDays: [],
      weightHistoryByExercise: {},
    );
  }

  WorkoutState copyWith({
    Map<String, Set<String>>? completedExerciseIdsByRoutine,
    Map<String, ExerciseDraftData>? exerciseDrafts,
    List<CompletedWorkoutDay>? completedWorkoutDays,
    Map<String, List<ExerciseWeightEntry>>? weightHistoryByExercise,
  }) {
    return WorkoutState(
      completedExerciseIdsByRoutine:
          completedExerciseIdsByRoutine ?? this.completedExerciseIdsByRoutine,
      exerciseDrafts: exerciseDrafts ?? this.exerciseDrafts,
      completedWorkoutDays: completedWorkoutDays ?? this.completedWorkoutDays,
      weightHistoryByExercise:
          weightHistoryByExercise ?? this.weightHistoryByExercise,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseDrafts': exerciseDrafts.map(
        (exerciseId, draft) => MapEntry(exerciseId, draft.toMap()),
      ),
      'completedWorkoutDays': completedWorkoutDays
          .map((entry) => entry.toMap())
          .toList(),
      'weightHistoryByExercise': weightHistoryByExercise.map(
        (exerciseId, entries) => MapEntry(
          exerciseId,
          entries.map((entry) => entry.toMap()).toList(),
        ),
      ),
    };
  }

  factory WorkoutState.fromMap(Map<dynamic, dynamic> map) {
    final rawDrafts = (map['exerciseDrafts'] as Map<dynamic, dynamic>?) ?? {};
    final rawHistory = (map['completedWorkoutDays'] as List<dynamic>?) ?? [];
    final rawWeightHistory =
        (map['weightHistoryByExercise'] as Map<dynamic, dynamic>?) ?? {};

    return WorkoutState(
      completedExerciseIdsByRoutine: const {},
      exerciseDrafts: rawDrafts.map(
        (key, value) => MapEntry(
          key.toString(),
          ExerciseDraftData.fromMap(value as Map<dynamic, dynamic>),
        ),
      ),
      completedWorkoutDays: rawHistory
          .map(
            (item) =>
                CompletedWorkoutDay.fromMap(item as Map<dynamic, dynamic>),
          )
          .toList(),
      weightHistoryByExercise: rawWeightHistory.map(
        (key, value) => MapEntry(
          key.toString(),
          (value as List<dynamic>)
              .map(
                (item) =>
                    ExerciseWeightEntry.fromMap(item as Map<dynamic, dynamic>),
              )
              .toList(),
        ),
      ),
    );
  }
}
