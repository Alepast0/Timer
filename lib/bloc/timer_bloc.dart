import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  final int _waitTimeInSec;
  int _currentWaitTimeInSec;

  TimerBloc({required int waitTimeInSec})
      : _waitTimeInSec = waitTimeInSec,
        _currentWaitTimeInSec = waitTimeInSec,
        super(InitTimerState(_calculationTime(waitTimeInSec), 1));

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  Stream<TimerState> mapEventToState(
      TimerEvent event,
      ) async* {
    if (event is TimerStartEvent) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPauseEvent) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResetEvent) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    } else if (event is TimerStopEvent) {
      yield* _mapTimerStopToState(event);
    }
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStartEvent start) async* {
    if (_currentWaitTimeInSec > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _currentWaitTimeInSec -= 1;
        add(TimerTicked(
            time: _calculationTime(_currentWaitTimeInSec),
            percent: _currentWaitTimeInSec / _waitTimeInSec));
        if (_currentWaitTimeInSec <= 0) {
          _timer?.cancel();
          add(const TimerStopEvent());
        }
      });

    }
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPauseEvent pause) async* {
    if (state is RunTimerState) {
      _timer?.cancel();
      yield PauseTimerState(_calculationTime(_currentWaitTimeInSec),
          _currentWaitTimeInSec / _waitTimeInSec);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerResetEvent reset) async* {
    _currentWaitTimeInSec = _waitTimeInSec;
    yield ResetTimerState(_calculationTime(_currentWaitTimeInSec),
        _currentWaitTimeInSec / _waitTimeInSec, state.isRun);
  }

  Stream<TimerState> _mapTimerStopToState(TimerStopEvent stop) async* {
    if (state is RunTimerState) {
      yield const CompleteTimerState();
    }
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield RunTimerState(tick.time, tick.percent);
  }

  static String _calculationTime(int currentWaitTimeInSec) {
    var hourStr = (currentWaitTimeInSec ~/ 3600).toString().padLeft(2, '0');
    var minuteStr = ((currentWaitTimeInSec % 3600) ~/ 60).toString().padLeft(2, '0');
    var secondStr = (currentWaitTimeInSec % 60).toString().padLeft(2, '0');
    return '$hourStr:$minuteStr:$secondStr';
  }
}