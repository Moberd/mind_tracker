import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/time_series_chart.dart';

class DayInformationWidget extends StatelessWidget {
  final String _yourMoodPhrase = "Your mood in that day";
  final String _yourMarkPhrase = "Your mark is";
  final DateTime _date;
  final String _mood;
  final int _mark;

  static final String _defaultMood =
      "Never gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you";

  DayInformationWidget(this._mood, this._mark, this._date);

  factory DayInformationWidget.withDefaultParams() {
    return new DayInformationWidget(_defaultMood, 7, new DateTime(2020, 12, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: new Column(
          children: [
            Flexible(
                flex: 1,
                child: new Text(
                  _yourMoodPhrase,
                  style: TextStyle(fontSize: 35),
                )),
            Expanded(
                flex: 15,
                child: new Scaffold(
                    backgroundColor: Color(0xFFFEF9FF),
                    body: new Text(
                      _mood,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ))),
            Flexible(
                flex: 1,
                child: new Text(
                  _yourMarkPhrase,
                  style: TextStyle(fontSize: 25),
                )),
            Flexible(
                flex: 1,
                child: new Text(
                  _mark.toString(),
                  style: TextStyle(fontSize: 25),
                )),
            Flexible(
                flex: 1,
                child: new Text(
                  "${_date.day}.${_date.month}.${_date.year}",
                  style: TextStyle(fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
