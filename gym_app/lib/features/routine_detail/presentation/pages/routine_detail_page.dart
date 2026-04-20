import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/domain/entities/exercise.dart';
import 'package:gym_app/domain/entities/routine.dart';
import 'package:gym_app/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:gym_app/features/routine_detail/presentation/widgets/exercise_list_item.dart';
import 'package:gym_app/features/routine_detail/presentation/widgets/exercise_section.dart';
import 'package:gym_app/features/routine_detail/presentation/widgets/routine_timer_card.dart';
import 'package:gym_app/features/workout_state/providers/workout_state_provider.dart';

class RoutineDetailPage extends ConsumerWidget {
  final Routine routine;

  const RoutineDetailPage({super.key, required this.routine});

  void _openExerciseDetail(BuildContext context, Exercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExerciseDetailPage(exercise: exercise)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(workoutStateProvider);
    final workoutNotifier = ref.read(workoutStateProvider.notifier);

    final pendingExercises = workoutNotifier.pendingExercisesForRoutine(
      routine,
    );
    final completedExercises = workoutNotifier.completedExercisesForRoutine(
      routine,
    );

    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: const RoutineTimerCard(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                children: [
                  ExerciseSection(
                    title: 'Pending',
                    child: pendingExercises.isEmpty
                        ? const _EmptyState(text: 'No pending exercises.')
                        : Column(
                            children: pendingExercises
                                .map(
                                  (exercise) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ExerciseListItem(
                                      exercise: exercise,
                                      isCompleted: false,
                                      onTap: () => _openExerciseDetail(
                                        context,
                                        exercise,
                                      ),
                                      onChanged: (_) async {
                                        workoutNotifier.setExerciseCompleted(
                                          routineId: routine.id,
                                          exerciseId: exercise.id,
                                          isCompleted: true,
                                        );

                                        final bool completed =
                                            await workoutNotifier
                                                .completeRoutineIfNeeded(
                                                  routine,
                                                );

                                        if (completed && context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${routine.name} completed',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 20),
                  ExerciseSection(
                    title: 'Completed',
                    child: completedExercises.isEmpty
                        ? const _EmptyState(
                            text: 'Completed exercises will appear here.',
                          )
                        : Column(
                            children: completedExercises
                                .map(
                                  (exercise) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ExerciseListItem(
                                      exercise: exercise,
                                      isCompleted: true,
                                      onTap: () => _openExerciseDetail(
                                        context,
                                        exercise,
                                      ),
                                      onChanged: (_) {
                                        workoutNotifier.setExerciseCompleted(
                                          routineId: routine.id,
                                          exerciseId: exercise.id,
                                          isCompleted: false,
                                        );
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
