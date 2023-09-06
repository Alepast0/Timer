import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  final int waitTimeInSec;

  const TimerPage({super.key, required this.waitTimeInSec});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(waitTimeInSec: waitTimeInSec),
      child: const _TimerPage(),
    );
  }
}

class _TimerPage extends StatelessWidget {
  const _TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state is CompleteTimerState){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Finish")));
            }
          },
          buildWhen: (prev, state) {
        return prev.runtimeType != state.runtimeType;
      }, builder: (context, state) {
        return Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurple[500]!, Colors.indigo[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    margin: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      value: context.select((TimerBloc bloc) => bloc.state.percent),
                      backgroundColor: Colors.purple[100],
                      color: Colors.purple[300],
                      strokeWidth: 4,
                    ),
                  ),
                  const Positioned(child: TimerText())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (state is! InitTimerState) ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.purple[100]!.withOpacity(0.3), width: 2)),
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.all(10),
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            onPressed: () {
                              context.read<TimerBloc>().add(const TimerResetEvent());
                            },
                            child: const Icon(
                              Icons.close,
                              size: 60,
                            ),
                          ),
                        ),
                        Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20, color: Colors.purple[100]),
                        )
                      ],
                    ),
                  ],
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.all(10),
                        child: FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Colors.purple[100]!.withOpacity(0.3),
                          onPressed: () {
                            state.isRun
                                ? context.read<TimerBloc>().add(const TimerPauseEvent())
                                : context.read<TimerBloc>().add(const TimerStartEvent());
                          },
                          child: state.isRun
                              ? const Icon(
                                  Icons.pause,
                                  size: 60,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  size: 60,
                                ),
                        ),
                      ),
                      Text(
                        state.isRun ? "Pause" : "Start",
                        style: TextStyle(fontSize: 20, color: Colors.purple[100]),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.select((TimerBloc bloc) => bloc.state.time),
      style: TextStyle(fontSize: 30, color: Colors.purple[100]),
    );
  }
}
