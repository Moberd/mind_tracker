///основной экран где должен осуществляться ввод данных

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainWindowWidget extends StatefulWidget {
  @override
  _MainWindowWidgetState createState() => _MainWindowWidgetState();
}

class _MainWindowWidgetState extends State<MainWindowWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SliderContainer(
                touch: () => setState((){}),
              ),
              Text("${digit.toInt()}")
            ],
          ),
        ),
      ),
    );
  }
}

double digit = 0;

class SliderContainer extends StatefulWidget {
  final void Function() touch;

  const SliderContainer({Key key, this.touch}) : super(key: key);
  @override
  _SliderContainerState createState() => _SliderContainerState();
}



class _SliderContainerState extends State<SliderContainer> {
  static double _lowerValue = 0;
  static double _upperValue = 10;
  @override
  Widget build(BuildContext context) {
    return Slider(
      divisions: 10,
      activeColor: Colors.deepPurple,
      inactiveColor: Colors.deepPurple[50],
      min: _lowerValue,
      max: _upperValue,
      value: digit,
      onChanged: (val) {
        digit = val;
        widget.touch();
      },
    );
  }
}