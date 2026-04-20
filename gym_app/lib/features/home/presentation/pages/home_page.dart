import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/data/seed/predefined_routines.dart';
import 'package:gym_app/domain/entities/routine.dart';
import 'package:gym_app/features/home/presentation/widgets/recommended_routine_banner.dart';
import 'package:gym_app/features/home/presentation/widgets/routine_card.dart';
import 'package:gym_app/features/home/presentation/widgets/two_week_calendar.dart';
import 'package:gym_app/features/routine_detail/presentation/pages/routine_detail_page.dart';
import 'package:gym_app/features/workout_state/providers/workout_state_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(workoutStateProvider);
    final workoutNotifier = ref.read(workoutStateProvider.notifier);

    final List<Routine> routines = PredefinedRoutines.routines;
    final Routine recommendedRoutine = workoutNotifier.getRecommendedRoutine(
      routines,
    );

    final Set<DateTime> completedDays = workoutNotifier
        .getCompletedCalendarDays();

    return Scaffold(
      appBar: AppBar(title: const Text('Gym App')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TwoWeekCalendar(
              visibleDates: _buildTwoWeekDates(),
              completedDays: completedDays,
            ),
            const SizedBox(height: 16),
            RecommendedRoutineBanner(
              recommendedRoutineName: recommendedRoutine.name,
              lastRoutineName: workoutNotifier.getLastCompletedRoutineName(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your routines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...routines.map(
              (routine) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RoutineCard(
                  routineName: routine.name,
                  isRecommended: routine.id == recommendedRoutine.id,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoutineDetailPage(routine: routine),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _buildTwoWeekDates() {
    final DateTime today = DateTime.now();
    final DateTime normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final int daysFromMonday = normalizedToday.weekday - DateTime.monday;
    final DateTime startOfCurrentWeek = normalizedToday.subtract(
      Duration(days: daysFromMonday),
    );

    final DateTime startOfTwoWeekBlock = startOfCurrentWeek.subtract(
      const Duration(days: 7),
    );

    return List.generate(
      14,
      (index) => startOfTwoWeekBlock.add(Duration(days: index)),
    );
  }
}
