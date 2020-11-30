import 'package:charts_flutter/flutter.dart' as charts;

///правый экран с календарем и статистикой
import 'package:flutter/material.dart';
import 'package:mind_tracker/time_series_chart.dart';

import 'day_information_widget.dart';

class CalendarWindowWidget extends StatelessWidget {
  /// Год окончания должен быть больше года начала, иначе ошибка,
  /// даже при одиом годе

  ///Если месяц - январь, календарь отработает ПРАВИЛЬНО
  final DateTime _beginningOfCalendar =
      new DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

  final DateTime _endingOfCalendar = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  CalendarWindowWidget();

  //TODO Доделать функцию отображения избранных дней.
  bool _isEven(DateTime a) {
    if (a.day < DateTime.now().day)
      return true;
    else
      return false;
  }

  void startDayStatisticPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DayInformationWidget.withDefaultParams()),
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
                flex: 1,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: _beginningOfCalendar,
                  lastDate: _endingOfCalendar,
                  onDateChanged: (value) => {startDayStatisticPage(context)},
                  ///selectableDayPredicate: _isEven,
                  currentDate: DateTime.now(),
                  initialCalendarMode: DatePickerMode.day,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: new TimeSeriesChart.withSampleData())
              )
            ], //children
          ),
        ));
  }
}
