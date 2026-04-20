import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class RoutineCard extends StatelessWidget {
  final String routineName;
  final bool isRecommended;
  final VoidCallback onTap;

  const RoutineCard({
    super.key,
    required this.routineName,
    required this.isRecommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isRecommended
        ? const Color(0xFF26361C)
        : AppColors.surface;

    final Color borderColor = isRecommended
        ? AppColors.accent
        : AppColors.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.3),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  routineName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
