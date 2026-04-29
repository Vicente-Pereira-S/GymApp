import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/features/timer_state/providers/rest_timer_provider.dart';

class RoutineTimerCard extends ConsumerWidget {
  const RoutineTimerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(restTimerProvider);
    final timerNotifier = ref.read(restTimerProvider.notifier);

    final int elapsedMilliseconds = timerState.elapsedMilliseconds();
    final Color activeColor = _timerColor(elapsedMilliseconds);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: timerState.isRunning
            ? AppColors.surfaceLight
            : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: timerState.isRunning ? activeColor : AppColors.border,
          width: timerState.isRunning ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            timerState.isRunning ? 'Rest timer running' : 'Rest timer',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formattedTime(elapsedMilliseconds),
              style: TextStyle(
                fontSize: 76,
                fontWeight: FontWeight.w800,
                color: activeColor,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _TimerButton(
                  label: timerState.isRunning ? 'Running' : 'Start',
                  onPressed: timerState.isRunning ? null : timerNotifier.start,
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimerButton(
                  label: 'Reset',
                  onPressed: timerNotifier.reset,
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimerButton(
                  label: 'Restart',
                  onPressed: timerNotifier.restart,
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _timerColor(int elapsedMilliseconds) {
    final int elapsedSeconds = elapsedMilliseconds ~/ 1000;

    if (elapsedSeconds < 90) {
      return AppColors.timerRed;
    }

    if (elapsedSeconds < 180) {
      return AppColors.timerYellow;
    }

    return AppColors.timerGreen;
  }

  String _formattedTime(int elapsedMilliseconds) {
    final int totalSeconds = elapsedMilliseconds ~/ 1000;
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final int deciseconds = (elapsedMilliseconds % 1000) ~/ 100;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '$deciseconds';
  }
}

class _TimerButton extends StatelessWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const _TimerButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () async {
                await onPressed!();
              },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isDisabled ? AppColors.completed : backgroundColor,
          foregroundColor: isDisabled
              ? AppColors.textSecondary
              : foregroundColor,
          disabledBackgroundColor: AppColors.completed,
          disabledForegroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
