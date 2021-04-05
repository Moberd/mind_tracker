import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> thoughtsList = [];
double digit = 0;
//*основной экран где должен осуществляться ввод данных
class MainWindowWidget extends StatefulWidget {
  @override
  _MainWindowWidgetState createState() => _MainWindowWidgetState();
}

class _MainWindowWidgetState extends State<MainWindowWidget> {

  @override
  void initState(){
    super.initState();
  }

  void getData() async  { //Получение с файрбеза
    print("works");
    String email = FirebaseAuth.instance.currentUser.email;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection("users").doc(email).collection("days").doc(formatted);
    await ref.get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        print(documentSnapshot.data());
        if(documentSnapshot.data()["mark"]!=null){
        digit = documentSnapshot.data()["mark"];
        }
        if(documentSnapshot.data()["thoughts"]!=null){
          print(documentSnapshot.data()["thoughts"]);
          thoughtsList = documentSnapshot.data()["thoughts"];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser.email;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection("users").doc(email).collection("days").doc(formatted);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return FutureBuilder<DocumentSnapshot>(
      future: ref.get(),
      builder: (context,snapshot){
        if(snapshot.data !=null) {
          if(snapshot.data.data()["mark"]!=null){
            digit = snapshot.data.data()["mark"];
          }
          if(snapshot.data.data()["thoughts"]!=null){
            thoughtsList =
            new List<String>.from(snapshot.data.data()["thoughts"]);
          }
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            //resizeToAvoidBottomPadding: false,
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
                    child: ThoughtBoxContainer(
                      touch: () => setState(() {}),
                    ),
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
      },
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
  List<String> thoughts =[];

  ThoughtsList({Key key, this.thoughts}) : super(key: key);
  @override
  _ThoughtsListState createState() => _ThoughtsListState();
}

class _ThoughtsListState extends State<ThoughtsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: thoughtsList.length,
        itemBuilder: (context, i) {
      return Card(
        child: ListTile(
          //title: Text("Never gonna give you up"),
          title: Text(thoughtsList[i])
        ),
      );
    });
  }

}

class ThoughtBoxContainer extends StatefulWidget {
  final void Function() touch;
  const ThoughtBoxContainer({Key key, this.touch}) : super(key: key);
  @override
  _ThoughtBoxContainerState createState() => _ThoughtBoxContainerState();
}

final _controller = TextEditingController();
void addThought(String value){
  thoughtsList.add(value);
  String email = FirebaseAuth.instance.currentUser.email;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(now);
  FirebaseFirestore.instance.collection("users").doc(email).collection("days").
      doc(formatted).update({"thoughts":thoughtsList});
}
class _ThoughtBoxContainerState extends State<ThoughtBoxContainer> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Your thoughts today',
        border: OutlineInputBorder(),
      ),
      controller: _controller,
      onFieldSubmitted: (value) {
        if (value != '') {
        addThought(value);
        }
        widget.touch();
        _controller.clear();
    }
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

void changeDigit(double value){
  String email = FirebaseAuth.instance.currentUser.email;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(now);
  FirebaseFirestore.instance.collection("users").doc(email).collection("days").
  doc(formatted).update({"mark":value});
}
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
        setState(() {
          digit = val;
        });
        print(digit);
        changeDigit(val);
      },
    );
  }
}

class RateDigitText extends StatefulWidget {
   double mark=0;

   RateDigitText({Key key, this.mark}) : super(key: key);
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
