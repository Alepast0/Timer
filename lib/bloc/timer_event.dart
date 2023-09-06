part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable{
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStartEvent extends TimerEvent {
  const TimerStartEvent();
}

class TimerPauseEvent extends TimerEvent {
  const TimerPauseEvent();
}

class TimerResetEvent extends TimerEvent {
  const TimerResetEvent();
}

class TimerStopEvent extends TimerEvent{
  const TimerStopEvent();
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.time, required this.percent});

  final String time;
  final double percent;

  @override
  List<Object> get props => [time];
}