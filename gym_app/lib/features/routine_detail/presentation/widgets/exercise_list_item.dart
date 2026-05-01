import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/domain/entities/exercise.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final String workoutDataText;
  final bool isCompleted;
  final VoidCallback onTap;
  final ValueChanged<bool?> onChanged;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    required this.workoutDataText,
    required this.isCompleted,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isCompleted ? 0.65 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.completed.withValues(alpha: 0.18)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isCompleted ? AppColors.completed : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workoutDataText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isCompleted,
                  onChanged: onChanged,
                  activeColor: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
