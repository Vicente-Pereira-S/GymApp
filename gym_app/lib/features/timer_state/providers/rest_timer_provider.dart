import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/core/services/notification_service.dart';
import 'package:gym_app/features/timer_state/state/rest_timer_state.dart';

final restTimerProvider =
    StateNotifierProvider<RestTimerNotifier, RestTimerState>(
      (ref) => RestTimerNotifier(),
    );

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _ticker;

  RestTimerNotifier() : super(RestTimerState.initial());

  Future<void> start() async {
    if (state.isRunning) {
      return;
    }

    state = state.copyWith(isRunning: true, startedAt: DateTime.now());

    _startTicker();

    await NotificationService.scheduleThreeMinuteAlert();
  }

  Future<void> reset() async {
    state = RestTimerState.initial();

    _stopTicker();

    await NotificationService.cancelThreeMinuteAlert();
  }

  Future<void> restart() async {
    state = RestTimerState.initial().copyWith(
      isRunning: true,
      startedAt: DateTime.now(),
    );

    _startTicker();

    await NotificationService.scheduleThreeMinuteAlert();
  }

  void _startTicker() {
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!state.isRunning) {
        return;
      }

      state = state.copyWith(tick: state.tick + 1);
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
