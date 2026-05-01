import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/core/storage/app_storage_keys.dart';
import 'package:gym_app/core/storage/local_storage_service.dart';
import 'package:gym_app/domain/entities/completed_workout_day.dart';
import 'package:gym_app/domain/entities/exercise.dart';
import 'package:gym_app/domain/entities/exercise_draft_data.dart';
import 'package:gym_app/domain/entities/exercise_weight_entry.dart';
import 'package:gym_app/domain/entities/routine.dart';
import 'package:gym_app/features/workout_state/state/workout_state.dart';

final workoutStateProvider =
    StateNotifierProvider<WorkoutStateNotifier, WorkoutState>(
      (ref) => WorkoutStateNotifier(),
    );

class WorkoutStateNotifier extends StateNotifier<WorkoutState> {
  WorkoutStateNotifier() : super(_loadInitialState());

  static WorkoutState _loadInitialState() {
    final dynamic rawData = LocalStorageService.read(
      AppStorageKeys.workoutState,
    );

    if (rawData is Map) {
      return WorkoutState.fromMap(rawData);
    }

    return WorkoutState.initial();
  }

  Future<void> _persistState() async {
    await LocalStorageService.write(AppStorageKeys.workoutState, state.toMap());
  }

  ExerciseDraftData getDraftForExercise(Exercise exercise) {
    return state.exerciseDrafts[exercise.id] ??
        ExerciseDraftData(
          sets: exercise.defaultSets,
          repsMin: exercise.defaultRepsMin,
          repsMax: exercise.defaultRepsMax,
          weightKg: null,
          permanentNote: exercise.permanentNote,
        );
  }

  List<ExerciseWeightEntry> getWeightHistoryForExercise(String exerciseId) {
    final entries =
        state.weightHistoryByExercise[exerciseId] ??
        const <ExerciseWeightEntry>[];
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  bool isExerciseCompleted({
    required String routineId,
    required String exerciseId,
  }) {
    final Set<String> completedIds =
        state.completedExerciseIdsByRoutine[routineId] ?? <String>{};

    return completedIds.contains(exerciseId);
  }

  List<Exercise> pendingExercisesForRoutine(Routine routine) {
    final Set<String> completedIds =
        state.completedExerciseIdsByRoutine[routine.id] ?? <String>{};

    return routine.exercises
        .where((exercise) => !completedIds.contains(exercise.id))
        .toList();
  }

  List<Exercise> completedExercisesForRoutine(Routine routine) {
    final Set<String> completedIds =
        state.completedExerciseIdsByRoutine[routine.id] ?? <String>{};

    return routine.exercises
        .where((exercise) => completedIds.contains(exercise.id))
        .toList();
  }

  void setExerciseCompleted({
    required String routineId,
    required String exerciseId,
    required bool isCompleted,
  }) {
    final Map<String, Set<String>> updatedMap = {
      ...state.completedExerciseIdsByRoutine,
    };

    final Set<String> currentSet = {...(updatedMap[routineId] ?? <String>{})};

    if (isCompleted) {
      currentSet.add(exerciseId);
    } else {
      currentSet.remove(exerciseId);
    }

    updatedMap[routineId] = currentSet;

    state = state.copyWith(completedExerciseIdsByRoutine: updatedMap);
  }

  Future<void> updateExerciseDraft({
    required Exercise exercise,
    int? sets,
    int? repsMin,
    int? repsMax,
    double? weightKg,
    String? permanentNote,
  }) async {
    final ExerciseDraftData current = getDraftForExercise(exercise);

    final Map<String, ExerciseDraftData> updatedDrafts = {
      ...state.exerciseDrafts,
      exercise.id: current.copyWith(
        sets: sets,
        repsMin: repsMin,
        repsMax: repsMax,
        weightKg: weightKg,
        permanentNote: permanentNote,
      ),
    };

    state = state.copyWith(exerciseDrafts: updatedDrafts);

    await _persistState();
  }

  bool isRoutineFullyCompleted(Routine routine) {
    final Set<String> completedIds =
        state.completedExerciseIdsByRoutine[routine.id] ?? <String>{};

    return routine.exercises.isNotEmpty &&
        completedIds.length == routine.exercises.length;
  }

  bool hasCompletedWorkoutOnDate(DateTime date) {
    return state.completedWorkoutDays.any(
      (entry) => _isSameDay(entry.date, date),
    );
  }

  CompletedWorkoutDay? getCompletedWorkoutForDate(DateTime date) {
    try {
      return state.completedWorkoutDays.firstWhere(
        (entry) => _isSameDay(entry.date, date),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> completeRoutineIfNeeded(Routine routine) async {
    if (!isRoutineFullyCompleted(routine)) {
      return false;
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final bool alreadyCompletedToday = hasCompletedWorkoutOnDate(today);

    if (alreadyCompletedToday) {
      return false;
    }

    final List<CompletedWorkoutDay> updatedHistory = [
      ...state.completedWorkoutDays,
      CompletedWorkoutDay(
        date: today,
        routineId: routine.id,
        routineName: routine.name,
      ),
    ];

    final Map<String, List<ExerciseWeightEntry>> updatedWeightHistory = {
      ...state.weightHistoryByExercise.map(
        (key, value) => MapEntry(key, [...value]),
      ),
    };

    for (final exercise in routine.exercises) {
      final draft = getDraftForExercise(exercise);
      final weight = draft.weightKg;

      if (weight != null && weight > 0) {
        final List<ExerciseWeightEntry> currentEntries = [
          ...(updatedWeightHistory[exercise.id] ?? <ExerciseWeightEntry>[]),
        ];

        currentEntries.add(
          ExerciseWeightEntry(
            date: today,
            exerciseId: exercise.id,
            weightKg: weight,
          ),
        );

        updatedWeightHistory[exercise.id] = currentEntries;
      }
    }

    final Map<String, Set<String>> updatedChecks = {
      ...state.completedExerciseIdsByRoutine,
    };
    updatedChecks.remove(routine.id);

    state = state.copyWith(
      completedWorkoutDays: updatedHistory,
      completedExerciseIdsByRoutine: updatedChecks,
      weightHistoryByExercise: updatedWeightHistory,
    );

    await _persistState();
    return true;
  }

  Routine getRecommendedRoutine(List<Routine> routines) {
    if (routines.isEmpty) {
      throw Exception('No routines available.');
    }

    if (state.completedWorkoutDays.isEmpty) {
      return routines.first;
    }

    final List<CompletedWorkoutDay> sortedHistory = [
      ...state.completedWorkoutDays,
    ]..sort((a, b) => a.date.compareTo(b.date));

    final CompletedWorkoutDay lastCompleted = sortedHistory.last;

    final Routine? lastRoutine = routines
        .where((routine) => routine.id == lastCompleted.routineId)
        .cast<Routine?>()
        .firstOrNull;

    if (lastRoutine == null) {
      return routines.first;
    }

    final int nextOrder = (lastRoutine.cycleOrder + 1) % routines.length;

    return routines.firstWhere(
      (routine) => routine.cycleOrder == nextOrder,
      orElse: () => routines.first,
    );
  }

  String getLastCompletedRoutineName() {
    if (state.completedWorkoutDays.isEmpty) {
      return 'None yet';
    }

    final List<CompletedWorkoutDay> sortedHistory = [
      ...state.completedWorkoutDays,
    ]..sort((a, b) => a.date.compareTo(b.date));

    return sortedHistory.last.routineName;
  }

  Set<DateTime> getCompletedCalendarDays() {
    return state.completedWorkoutDays
        .map(
          (entry) =>
              DateTime(entry.date.year, entry.date.month, entry.date.day),
        )
        .toSet();
  }

  void resetRoutineSession(String routineId) {
    final Map<String, Set<String>> updatedMap = {
      ...state.completedExerciseIdsByRoutine,
    };

    updatedMap.remove(routineId);

    state = state.copyWith(completedExerciseIdsByRoutine: updatedMap);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }

    return first;
  }
}
