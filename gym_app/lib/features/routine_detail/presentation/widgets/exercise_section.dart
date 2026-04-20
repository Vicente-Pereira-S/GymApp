import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class ExerciseSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ExerciseSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
