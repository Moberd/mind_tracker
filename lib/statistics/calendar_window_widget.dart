
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/calendar_window_logic.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

import 'calendar_page_logic.dart';
import 'day_information_widget.dart';

class CalendarWindowWidgetWrapper extends StatefulWidget {
  @override
  _CalendarWindowWidgetWrapperState createState() => _CalendarWindowWidgetWrapperState();
}

class _CalendarWindowWidgetWrapperState extends State<CalendarWindowWidgetWrapper> {
  CalendarBloc _bloc = new CalendarBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.calendarPage,

      initialData: Container(width: 0.0, height: 0.0) ,


      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data;
      },
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
  CalendarPageBloc _bloc;

  Map<DateTime, BaseData> thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart timeSeriesChart;

  CalendarWindowWidgetState(this.thoughts) {
    _bloc= new CalendarPageBloc(thoughts: thoughts);
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
                child: StreamBuilder(
                  stream: _bloc.pred,
                  builder: (BuildContext context, AsyncSnapshot<bool Function(DateTime)> snapshot)
                  {
                    return CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: new DateTime(DateTime.now().year, DateTime.now().month - 10, 1),
                      lastDate: new DateTime(
                          DateTime.now().year, DateTime.now().month, DateTime.now().day),
                      onDateChanged: (value) =>
                      {_bloc.statisticPageEventSink.add(new DayStaticsticEvent(context: context,dateTime: value))},
                      selectableDayPredicate: snapshot.data,
                      currentDate: DateTime.now(),
                      initialCalendarMode: DatePickerMode.day,
                      onDisplayedMonthChanged: (value) =>{
                        _bloc.chartsUpdateEventSink.add(new UpdateChartsEvent(val: value))
                      },
                    );
                  },
                ),
              ),
              Expanded(
                  flex: 10,
                  child: new Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: StreamBuilder(
                        initialData: Container(width: 0.0, height: 0.0),
                        stream: _bloc.timeSeriesCharts,
                        builder: (context, snapshot) {
                          return snapshot.data;
                        },
                      )))
            ], //children
          ),
        ));
  }
}
