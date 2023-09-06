part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState(this.time, this.percent, this.isRun);
  final double percent;
  final String time;
  final bool isRun;

  @override
  List<Object> get props => [time, percent];
}

class InitTimerState extends TimerState {
  const InitTimerState(String time, double percent) : super(time, percent, false);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}

class RunTimerState extends TimerState{
  const RunTimerState(String time, double percent) : super(time, percent, true);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}

class PauseTimerState extends TimerState{
  const PauseTimerState(String time, double percent) : super(time, percent, false);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}

class ResetTimerState extends TimerState{
  const ResetTimerState(String time, double percent, bool isRun) : super(time, percent, isRun);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}

class CompleteTimerState extends TimerState {
  const CompleteTimerState() : super('00:00:00', 0, false);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}