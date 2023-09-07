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
        super(InitTimerState(_calculationTime(waitTimeInSec), 1)) {
    on<TimerStartEvent>(_timerStarted);
    on<TimerPauseEvent>(_timerPaused);
    on<TimerResetEvent>(_timerReset);
    on<TimerTicked>(_ticked);
    on<TimerStopEvent>(_timerStop);
  }

  void _timerStarted(TimerStartEvent event, Emitter<TimerState> emit) {
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

  void _timerPaused(TimerPauseEvent event, Emitter<TimerState> emit) {
    if (state is RunTimerState) {
      _timer?.cancel();
      emit(PauseTimerState(
          _calculationTime(_currentWaitTimeInSec), _currentWaitTimeInSec / _waitTimeInSec));
    }
  }

  void _timerReset(TimerResetEvent event, Emitter<TimerState> emit) {
    _currentWaitTimeInSec = _waitTimeInSec;
    emit(ResetTimerState(_calculationTime(_currentWaitTimeInSec),
        _currentWaitTimeInSec / _waitTimeInSec, state is RunTimerState));
  }

  void _timerStop(TimerStopEvent event, Emitter<TimerState> emit) {
    if (state is RunTimerState) {
      emit(const CompleteTimerState());
    }
  }

  void _ticked(TimerTicked event, Emitter<TimerState> emit) {
    emit(RunTimerState(event.time, event.percent));
  }

  static String _calculationTime(int currentWaitTimeInSec) {
    var hourStr = (currentWaitTimeInSec ~/ 3600).toString().padLeft(2, '0');
    var minuteStr = ((currentWaitTimeInSec % 3600) ~/ 60).toString().padLeft(2, '0');
    var secondStr = (currentWaitTimeInSec % 60).toString().padLeft(2, '0');
    return '$hourStr:$minuteStr:$secondStr';
  }
}
