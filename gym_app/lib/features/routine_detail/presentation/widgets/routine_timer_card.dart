import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_app/app/theme/app_colors.dart';
import 'package:gym_app/core/services/notification_service.dart';

class RoutineTimerCard extends StatefulWidget {
  const RoutineTimerCard({super.key});

  @override
  State<RoutineTimerCard> createState() => _RoutineTimerCardState();
}

class _RoutineTimerCardState extends State<RoutineTimerCard> {
  Timer? _ticker;
  AppLifecycleListener? _lifecycleListener;

  bool _isRunning = false;
  DateTime? _startedAt;
  int _accumulatedSeconds = 0;

  @override
  void initState() {
    super.initState();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        if (mounted) {
          setState(() {});
          _startTickerIfNeeded();
        }
      },
      onPause: () {
        _stopTicker();
      },
      onInactive: () {
        _stopTicker();
      },
      onDetach: () {
        _stopTicker();
      },
    );
  }

  @override
  void dispose() {
    _stopTicker();
    _lifecycleListener?.dispose();
    super.dispose();
  }

  int get _elapsedSeconds {
    if (!_isRunning || _startedAt == null) {
      return _accumulatedSeconds;
    }

    final int runningSeconds = DateTime.now().difference(_startedAt!).inSeconds;
    return _accumulatedSeconds + runningSeconds;
  }

  void _startTickerIfNeeded() {
    if (!_isRunning) {
      return;
    }

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> _startTimer() async {
    if (_isRunning) {
      return;
    }

    _startedAt = DateTime.now();
    _isRunning = true;

    setState(() {});
    _startTickerIfNeeded();

    await NotificationService.scheduleThreeMinuteAlert();
  }

  Future<void> _stopTimer() async {
    if (_isRunning && _startedAt != null) {
      _accumulatedSeconds = _elapsedSeconds;
    }

    _isRunning = false;
    _startedAt = null;

    _stopTicker();
    setState(() {});

    await NotificationService.cancelThreeMinuteAlert();
  }

  Future<void> _resetTimer() async {
    _isRunning = false;
    _startedAt = null;
    _accumulatedSeconds = 0;

    _stopTicker();
    setState(() {});

    await NotificationService.cancelThreeMinuteAlert();
  }

  Color _timerColor() {
    final elapsed = _elapsedSeconds;

    if (elapsed < 90) {
      return AppColors.timerRed;
    }

    if (elapsed < 180) {
      return AppColors.timerYellow;
    }

    return AppColors.timerGreen;
  }

  String _formattedTime() {
    final int minutes = _elapsedSeconds ~/ 60;
    final int seconds = _elapsedSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
  final Future<void> Function() onPressed;
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
        onPressed: () async {
          await onPressed();
        },
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
