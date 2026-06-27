import 'dart:async';

class FocusState {
  final bool isFocused;
  final int focusStreak;
  final int totalFocusMinutes;
  final DateTime? sessionStart;

  const FocusState({
    this.isFocused = false,
    this.focusStreak = 0,
    this.totalFocusMinutes = 0,
    this.sessionStart,
  });

  FocusState copyWith({
    bool? isFocused,
    int? focusStreak,
    int? totalFocusMinutes,
    DateTime? sessionStart,
  }) {
    return FocusState(
      isFocused: isFocused ?? this.isFocused,
      focusStreak: focusStreak ?? this.focusStreak,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }
}

class FocusSupportService {
  FocusState _state = const FocusState();
  Timer? _focusTimer;
  int _elapsedSeconds = 0;

  FocusState get state => _state;

  void startFocusSession() {
    _state = _state.copyWith(
      isFocused: true,
      sessionStart: DateTime.now(),
    );
    _elapsedSeconds = 0;
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      if (_elapsedSeconds % 60 == 0) {
        _state = _state.copyWith(
          totalFocusMinutes: _state.totalFocusMinutes + 1,
        );
      }
    });
  }

  void endFocusSession() {
    _focusTimer?.cancel();
    _focusTimer = null;
    _state = _state.copyWith(
      isFocused: false,
      focusStreak: _state.focusStreak + 1,
    );
  }

  void breakFocus() {
    _focusTimer?.cancel();
    _focusTimer = null;
    _state = _state.copyWith(
      isFocused: false,
      focusStreak: 0,
    );
  }

  int get currentStreak => _state.focusStreak;

  int get totalMinutes => _state.totalFocusMinutes;

  void dispose() {
    _focusTimer?.cancel();
  }
}
