import 'package:flutter/material.dart';
import 'package:timer/view/timer_page.dart';

class TimeSelectionPage extends StatefulWidget {
  const TimeSelectionPage({super.key});

  @override
  State<TimeSelectionPage> createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  int selectedTime = 1;

  List<String> timeUnits = ['Second', 'Minute', 'Hour'];
  String selectedTimeUnit = 'Second';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepPurple[500]!, Colors.indigo[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton<int>(
            dropdownColor: Colors.purple[500]!,
            value: selectedTime,
            items: List.generate(
                60,
                (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}', style: TextStyle(fontSize: 20, color: Colors.purple[100]),),
                    )),
            onChanged: (value) {
              setState(() {
                selectedTime = value!;
              });
            },
          ),
          DropdownButton<String>(
            dropdownColor: Colors.purple[500]!,
            value: selectedTimeUnit,
            items: timeUnits.map((unit) {
              return DropdownMenuItem<String>(
                value: unit,
                child: Text(unit, style: TextStyle(fontSize: 20, color: Colors.purple[100]),),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTimeUnit = value!;
              });
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 20),
              elevation: 0,
              primary: Colors.purple[100]!.withOpacity(0.3)
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                selectedTimeUnit == "Minute"
                    ? selectedTime = selectedTime * 60
                    : selectedTimeUnit == "Hour"
                        ? selectedTime = 3600 * selectedTime
                        : selectedTime;
                return TimerPage(waitTimeInSec: selectedTime);
              }));
            },
            child: const Text('Set'),
          ),
        ],
      )),
    );
  }
}
