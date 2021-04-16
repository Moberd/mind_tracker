
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///правый экран с календарем и статистикой
import 'package:flutter/material.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

import 'day_information_widget.dart';

class CalendarWindowWidgetWrapper extends StatefulWidget {
  @override
  _CalendarWindowWidgetWrapperState createState() => _CalendarWindowWidgetWrapperState();
}

class _CalendarWindowWidgetWrapperState extends State<CalendarWindowWidgetWrapper> {
  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser.email;
    return new FutureBuilder<QuerySnapshot>(
      future:FirebaseFirestore.instance.collection("users").doc(email).collection("days").get(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        print(snapshot);
        if(snapshot == null) {
          print("just null");
          return new Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data==null){
          print("data null");
          return new Center(child: CircularProgressIndicator(),);
        }
        Map<DateTime,BaseData> thoughts = {};
        for(DocumentSnapshot doc in snapshot.data.docs){
          final ddMMyyyy= doc.id.split("-");
            int mark;
          try{
            mark = doc.data()["mark"];
          }catch(e){
            mark = 0;
          }

          List<String> thoughtsLst;
          try {
          thoughtsLst = new List<String>.from(
                doc.data()["thoughts"]);
          }catch(e){
            thoughtsLst = [];
          }
          final date = new DateTime(int.parse(ddMMyyyy[2]),int.parse(ddMMyyyy[1]),int.parse(ddMMyyyy[0]));
          thoughts[date] = new BaseData(date, thoughtsLst, mark);
        }
        print(thoughts);
        return CalendarWindowWidget(thoughts: thoughts,);
      } ,
    );
  }
}


class CalendarWindowWidget extends StatefulWidget {
  final Map<DateTime,BaseData> thoughts;

  const CalendarWindowWidget({Key key, this.thoughts}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new CalendarWindowWidgetState(thoughts);
  }
}

class CalendarWindowWidgetState extends State<CalendarWindowWidget> {
  final DateTime _beginningOfCalendar =
      new DateTime(DateTime.now().year, DateTime.now().month - 10, 1);

  final DateTime _endingOfCalendar = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<DateTime, BaseData> thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart timeSeriesChart;
  CalendarWindowWidgetState(this.thoughts) {
   // getThoughts();
    List<charts.Series<TimeSeriesSales, DateTime>> list;
    timeSeriesChart =
        new TimeSeriesChart(GetChartsData(thoughts, DateTime.now()));
  }

  List<charts.Series<TimeSeriesSales, DateTime>> GetChartsData(
      Map<DateTime, BaseData> map, DateTime day) {
    List<TimeSeriesSales> res = [];
    map.keys.forEach((element) {
      if (element.year == day.year && element.month == day.month)
        res.add(new TimeSeriesSales(element, map[element].mark));
    });
    print(res.length);
    if(res.length ==0)
      {
        res.add(new TimeSeriesSales(new DateTime(day.year,day.month,1), 0));
        res.add(new TimeSeriesSales(new DateTime(day.year,day.month,28), 0));
      }
    return [
      new charts.Series(
          id: 'Sales',
          data: res,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales)
    ];
  }

  void getThoughts() {
   // thoughts = widget.thoughts;
//  List<String> mood1 = [
//    "Never gonna give you up",
//    "Never gonna let you down",
//    "Never gonna run around and desert you",
//    "Never gonna make you cry",
//    "Never gonna say goodbye",
//    "Never gonna tell a lie and hurt you"
//  ];
//  List<String> mood2 = ["Приветульки", "Сегодня мы играем", "Маинкрафт"];
//  DateTime dtTest = DateTime.now();
//  DateTime dt1 = new DateTime(dtTest.year, dtTest.month, dtTest.day);
//  DateTime dt2 = new DateTime(dtTest.year, dtTest.month, dtTest.day - 1);

//  //Timestamp ts1 = Timestamp.fromDate(dt1);
//  //Timestamp ts2 = Timestamp.fromDate(dt2);
//  thoughts[dt1] = new BaseData(dt1, mood1, 5);
//  thoughts[dt2] = new BaseData(dt2, mood2, 9);
  }

  bool _isRightDay(DateTime a) {
    //Timestamp ts = Timestamp.fromDate(a);
    DateTime date = DateTime.now();
    DateTime d1 = new DateTime(a.year, a.month, a.day);
    DateTime d2 = new DateTime(date.year, date.month, date.day);

    if (thoughts.containsKey(a) || d1.compareTo(d2) == 0)
      return true;
    else
      return false;
  }

  void startDayStatisticPage(BuildContext context, DateTime d) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context)
          {
            if(!thoughts.containsKey(d))
              thoughts[d]=new BaseData(d, new List<String>(), 0);

            if(thoughts[d].thoughts == null)
              thoughts[d].thoughts = new List<String>();
            if(thoughts[d].mark == null)
              thoughts[d].mark=0;
            return DayInformationWidget(d, thoughts[d].thoughts, thoughts[d].mark);  }


          ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 12,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: _beginningOfCalendar,
                  lastDate: _endingOfCalendar,
                  onDateChanged: (value) =>
                      {startDayStatisticPage(context, value)},
                  selectableDayPredicate: _isRightDay,
                  currentDate: DateTime.now(),
                  initialCalendarMode: DatePickerMode.day,
                  onDisplayedMonthChanged: (value) =>{
                    timeSeriesChart.ts.updateCharts(GetChartsData(thoughts,value)),
                    timeSeriesChart.ts.setState(() {

                    })
                  },
                ),
              ),
              Expanded(
                  flex: 10,
                  child: new Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: timeSeriesChart))
            ], //children
          ),
        ));
  }
}
