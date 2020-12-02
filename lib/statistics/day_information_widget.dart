import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

final List<String> _defaultMood = [
  "Never gonna give you up",
  "Never gonna let you down",
  "Never gonna run around and desert you",
  "Never gonna make you cry",
  "Never gonna say goodbye",
  "Never gonna tell a lie and hurt you"
];


class DayInformationWidget extends StatelessWidget {
  final String _yourMoodPhrase = "Your thoughts at that day: ";
  final String _yourMarkPhrase = "Your mood mark was";
  final DateTime _date = DateTime(2020, 12, 1);
  final List<String> _mood = _defaultMood;
  final int _mark = 7;

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
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                  flex: 1,
                  child: Text(
                    _yourMoodPhrase,
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.deepPurple,
                    ),
                  )),
            ),
            SizedBox(),
            Expanded(
                flex: 15,
                child: MyThoughtsList(),
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
                  style: TextStyle(fontSize: 17,color: Color(0xFF736CED)),
                )),
          ],
        ),
      ),
    );
  }
}

class MyThoughtsList extends StatefulWidget {
  @override
  _MyThoughtsListState createState() => _MyThoughtsListState();
}

class _MyThoughtsListState extends State<MyThoughtsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _defaultMood.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ListTile(
                title: Text(
                  "${i+1}) " + _defaultMood[i],
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
