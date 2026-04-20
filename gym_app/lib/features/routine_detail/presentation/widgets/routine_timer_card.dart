import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class RoutineTimerCard extends StatefulWidget {
  const RoutineTimerCard({super.key});

  @override
  State<RoutineTimerCard> createState() => _RoutineTimerCardState();
}

class _RoutineTimerCardState extends State<RoutineTimerCard> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();

    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
    });
  }

  Color _timerColor() {
    if (_elapsedSeconds < 90) {
      return AppColors.timerRed;
    }

    if (_elapsedSeconds < 180) {
      return AppColors.timerYellow;
    }

    return AppColors.timerGreen;
  }

  String _formattedTime() {
    final int minutes = _elapsedSeconds ~/ 60;
    final int seconds = _elapsedSeconds % 60;

    final String minutesText = minutes.toString().padLeft(2, '0');
    final String secondsText = seconds.toString().padLeft(2, '0');

    return '$minutesText:$secondsText';
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = _timerColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Rest timer',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formattedTime(),
              style: TextStyle(
                fontSize: 84,
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
                  label: 'Start',
                  onPressed: _startTimer,
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimerButton(
                  label: 'Stop',
                  onPressed: _stopTimer,
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimerButton(
                  label: 'Reset',
                  onPressed: _resetTimer,
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
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
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
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
