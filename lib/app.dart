import 'package:flutter/material.dart';
import 'package:timer/view/time_selection_page.dart';
import 'package:timer/view/timer_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: TimeSelectionPage()
      ),
    );
  }
}
