import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';




class DayInformationWidget extends StatefulWidget {
  final String _yourMoodPhrase = "Your thoughts at that day: ";
  final String _yourMarkPhrase = "Your mood mark was";
  DateTime _date ;
  int _mark = 7;
  List<String> _myThoughts = [];

  DayInformationWidget(DateTime date,List<String> list,int mark)
  {
    _myThoughts = list;
    _date = date;
    _mark = mark;
  }

  @override
  State<StatefulWidget> createState() {
    return new DayInformationWidgetState(_date,_myThoughts,_mark);
  }
}

class DayInformationWidgetState extends State<DayInformationWidget> {
  final String _yourMoodPhrase = "Your thoughts at that day: ";
  final String _yourMarkPhrase = "Your mood mark was";
  int _mark;
  List<String> _myThoughts = [];
  DateTime _date;

  DayInformationWidgetState(DateTime d, List<String> list, int mark) {
    this._mark = mark;
    this._myThoughts = list;
    this._date = d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9FF),
      appBar: AppBar(
        title: Text("Day statistics"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _yourMoodPhrase,
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(),
            Expanded(
              flex: 15,
              child: MyThoughtsList(_myThoughts),
            ),
            Flexible(
                flex: 1,
                child: Text(
                  _yourMarkPhrase,
                  style: TextStyle(fontSize: 25),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  child: Text(
                    _mark.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  alignment: Alignment.center,
                )
            ),
            Flexible(
                flex: 1,
                child: new Text(
                  "${_date.day}.${_date.month}.${_date.year}",
                  style: TextStyle(fontSize: 17, color: Color(0xFF736CED)),
                )),
          ],
        ),
      ),
    );
  }

}

// ignore: must_be_immutable
class MyThoughtsList extends StatefulWidget {
  List<String> _myThoughts;
  MyThoughtsList(List<String> l){_myThoughts=l;}
  @override
  _MyThoughtsListState createState() => _MyThoughtsListState(_myThoughts);
}

class _MyThoughtsListState extends State<MyThoughtsList> {
  List<String> _myThoughts;
  _MyThoughtsListState(List<String> l){_myThoughts=l;}
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _myThoughts.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ListTile(
                title: Text(
                  "${i+1}) " + _myThoughts[i],
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 23,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ),
          );
        });
  }
}
