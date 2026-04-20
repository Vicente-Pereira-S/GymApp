import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class RecommendedRoutineBanner extends StatelessWidget {
  final String recommendedRoutineName;
  final String lastRoutineName;

  const RecommendedRoutineBanner({
    super.key,
    required this.recommendedRoutineName,
    required this.lastRoutineName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6FAE3F), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended today',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendedRoutineName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last completed: $lastRoutineName',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
