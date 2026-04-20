import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/domain/entities/exercise.dart';

class ExerciseHeader extends StatelessWidget {
  final Exercise exercise;

  const ExerciseHeader({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 34,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            exercise.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
