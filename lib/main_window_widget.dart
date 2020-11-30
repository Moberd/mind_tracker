import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//*основной экран где должен осуществляться ввод данных
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
        backgroundColor: Color(0xFFFEF9FF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HowAreYouText(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/meditation.gif',
                  height: 350,
                  width: 350,
                ),
              ),
              //TODO расширить поле ввода
              Padding(
                padding: const EdgeInsets.all(20),
                child: ThoughtBoxContainer(),
              ),
              //TODO добавить картиночки плохо ок хорошо
              Padding(
                padding: const EdgeInsets.only(top:40.0,left:10.0,right: 10.0),
                child: SliderContainer(
                    touch: () => setState((){}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: RateDigitText(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HowAreYouText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "How are you today?",
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 40
      ),
    );
  }
}

class ThoughtBoxContainer extends StatefulWidget {
  @override
  _ThoughtBoxContainerState createState() => _ThoughtBoxContainerState();
}

class _ThoughtBoxContainerState extends State<ThoughtBoxContainer> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          filled: true,
          labelText: 'Your thoughts today',
        ),
        onChanged: (value) {
          setState(() {});
        },
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

class RateDigitText extends StatefulWidget {
  @override
  _RateDigitTextState createState() => _RateDigitTextState();
}

class _RateDigitTextState extends State<RateDigitText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "${digit.toInt()}",
      style: TextStyle(
        fontSize: 30
      ),
    );
  }
}