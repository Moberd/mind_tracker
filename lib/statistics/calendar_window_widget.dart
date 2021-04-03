import 'package:charts_flutter/flutter.dart' as charts;

///правый экран с календарем и статистикой
import 'package:flutter/material.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

import 'day_information_widget.dart';

class CalendarWindowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CalendarWindowWidgetState();
  }
}

class CalendarWindowWidgetState extends State<CalendarWindowWidget> {
  final DateTime _beginningOfCalendar =
      new DateTime(DateTime.now().year, DateTime.now().month - 10, 1);

  final DateTime _endingOfCalendar = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<DateTime, BaseData> thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart timeSeriesChart;


  CalendarWindowWidgetState() {
    getThoughts();
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
    List<String> mood1 = [
      "Never gonna give you up",
      "Never gonna let you down",
      "Never gonna run around and desert you",
      "Never gonna make you cry",
      "Never gonna say goodbye",
      "Never gonna tell a lie and hurt you"
    ];
    List<String> mood2 = ["Приветульки", "Сегодня мы играем", "Маинкрафт"];
    DateTime dtTest = DateTime.now();
    DateTime dt1 = new DateTime(dtTest.year, dtTest.month, dtTest.day);
    DateTime dt2 = new DateTime(dtTest.year, dtTest.month, dtTest.day - 1);

    //Timestamp ts1 = Timestamp.fromDate(dt1);
    //Timestamp ts2 = Timestamp.fromDate(dt2);
    thoughts[dt1] = new BaseData(dt1, mood1, 5);
    thoughts[dt2] = new BaseData(dt2, mood2, 9);
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
          builder: (context) =>
              DayInformationWidget(d, thoughts[d].thoughts, 5)),
    );
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
