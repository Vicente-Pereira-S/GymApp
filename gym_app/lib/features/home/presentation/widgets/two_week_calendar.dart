import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/features/home/presentation/widgets/day_tooltip.dart';
import 'package:gym_app/features/workout_state/providers/workout_state_provider.dart';

class TwoWeekCalendar extends ConsumerStatefulWidget {
  final List<DateTime> visibleDates;
  final Set<DateTime> completedDays;

  const TwoWeekCalendar({
    super.key,
    required this.visibleDates,
    required this.completedDays,
  });

  @override
  ConsumerState<TwoWeekCalendar> createState() => _TwoWeekCalendarState();
}

class _TwoWeekCalendarState extends ConsumerState<TwoWeekCalendar> {
  OverlayEntry? _activeTooltipEntry;
  DateTime? _activeTooltipDate;

  @override
  void dispose() {
    _removeActiveTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> firstWeek = widget.visibleDates.take(7).toList();
    final List<DateTime> secondWeek = widget.visibleDates
        .skip(7)
        .take(7)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildWeekdayHeader(),
          const SizedBox(height: 12),
          _buildWeekRow(firstWeek),
          const SizedBox(height: 10),
          _buildWeekRow(secondWeek),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const List<String> weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Row(
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildWeekRow(List<DateTime> weekDates) {
    return Row(
      children: weekDates
          .map(
            (date) => Expanded(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) => _handleDayTap(date, details),
                  child: _CalendarDay(
                    dayNumber: date.day,
                    isCompleted: _isSameDayContained(date),
                    isToday: _isSameDay(date, DateTime.now()),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _handleDayTap(DateTime date, TapDownDetails details) {
    final workoutNotifier = ref.read(workoutStateProvider.notifier);
    final completedWorkout = workoutNotifier.getCompletedWorkoutForDate(date);

    if (completedWorkout == null) {
      _removeActiveTooltip();
      return;
    }

    if (_activeTooltipEntry != null && _activeTooltipDate != null) {
      if (_isSameDay(_activeTooltipDate!, date)) {
        _removeActiveTooltip();
        return;
      }

      _removeActiveTooltip();
    }

    final overlay = Overlay.of(context);

    final OverlayEntry entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: details.globalPosition.dx - 50,
          top: details.globalPosition.dy - 62,
          child: DayTooltip(text: completedWorkout.routineName),
        );
      },
    );

    _activeTooltipEntry = entry;
    _activeTooltipDate = DateTime(date.year, date.month, date.day);

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }

      if (_activeTooltipEntry == entry) {
        _removeActiveTooltip();
      }
    });
  }

  void _removeActiveTooltip() {
    _activeTooltipEntry?.remove();
    _activeTooltipEntry = null;
    _activeTooltipDate = null;
  }

  bool _isSameDayContained(DateTime date) {
    return widget.completedDays.any(
      (completedDate) => _isSameDay(completedDate, date),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _CalendarDay extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final bool isToday;

  const _CalendarDay({
    required this.dayNumber,
    required this.isCompleted,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color backgroundColor = Colors.transparent;
    Color textColor = AppColors.textPrimary;

    if (isCompleted) {
      borderColor = AppColors.timerGreen;
      backgroundColor = AppColors.timerGreen.withValues(alpha: 0.12);
    } else if (isToday) {
      borderColor = AppColors.border;
      backgroundColor = AppColors.surfaceLight;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$dayNumber',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
