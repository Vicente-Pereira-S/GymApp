class RestTimerState {
  final bool isRunning;
  final DateTime? startedAt;
  final int accumulatedMilliseconds;
  final int tick;

  const RestTimerState({
    required this.isRunning,
    required this.startedAt,
    required this.accumulatedMilliseconds,
    required this.tick,
  });

  factory RestTimerState.initial() {
    return const RestTimerState(
      isRunning: false,
      startedAt: null,
      accumulatedMilliseconds: 0,
      tick: 0,
    );
  }

  int elapsedMilliseconds() {
    if (!isRunning || startedAt == null) {
      return accumulatedMilliseconds;
    }

    return accumulatedMilliseconds +
        DateTime.now().difference(startedAt!).inMilliseconds;
  }

  RestTimerState copyWith({
    bool? isRunning,
    DateTime? startedAt,
    int? accumulatedMilliseconds,
    int? tick,
    bool clearStartedAt = false,
  }) {
    return RestTimerState(
      isRunning: isRunning ?? this.isRunning,
      startedAt: clearStartedAt ? null : startedAt ?? this.startedAt,
      accumulatedMilliseconds:
          accumulatedMilliseconds ?? this.accumulatedMilliseconds,
      tick: tick ?? this.tick,
    );
  }
}
