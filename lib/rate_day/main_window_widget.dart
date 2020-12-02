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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFFEF9FF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: HowAreYouText(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(
                  'assets/meditation_3.gif',
                  height: 250,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ThoughtsList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: bottom),
                child: ThoughtBoxContainer(),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconsRow(),
                ),
              ),
              SliderContainer(
                touch: () => setState(() {}),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child:RateDigitText(),
              ),
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
      style: TextStyle(color: Colors.deepPurple, fontSize: 40),
    );
  }
}

class ThoughtsList extends StatefulWidget {
  @override
  _ThoughtsListState createState() => _ThoughtsListState();
}

class _ThoughtsListState extends State<ThoughtsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, i) {
      return Card(
        child: ListTile(
          title: Text("Never gonna give you up"),
        ),
      );
    });
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
        labelText: 'Your thoughts today',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

class IconsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.thumb_down, size: 30, color: Colors.deepPurple),
        Icon(Icons.check, size: 30, color: Colors.deepPurple),
        Icon(Icons.thumb_up, size: 30, color: Colors.deepPurple)
      ],
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
    return Container(
      child: Text(
        "${digit.toInt()}",
        style: TextStyle(fontSize: 30),
      ),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black, width: 1),
      ),
      alignment: Alignment.center,
    );
  }
}