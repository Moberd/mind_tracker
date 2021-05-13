import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

import 'day_information_widget.dart';

class UpdateChartsEvent {
  DateTime val;

  UpdateChartsEvent({this.val});
}

class DayStaticsticEvent {
  BuildContext context;
  DateTime dateTime;

  DayStaticsticEvent({this.context, this.dateTime});
}

class CalendarPageBloc {
  Map<DateTime, BaseData> _thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart _timeSeriesChart;

  final StreamController<TimeSeriesChart> _chartsStateController =
      StreamController<TimeSeriesChart>();

  StreamSink<TimeSeriesChart> get _inTimeSeriesCharts =>
      _chartsStateController.sink;

  Stream<TimeSeriesChart> get timeSeriesCharts => _chartsStateController.stream;
  final _chartsEventController = StreamController<UpdateChartsEvent>();

  Sink<UpdateChartsEvent> get chartsUpdateEventSink =>
      _chartsEventController.sink;
  final _startDayStatisticPageController =
      StreamController<DayStaticsticEvent>();

  Sink<DayStaticsticEvent> get statisticPageEventSink =>
      _startDayStatisticPageController.sink;

  final StreamController<bool Function(DateTime)> _predStateController =
      StreamController<bool Function(DateTime)>();

  StreamSink<bool Function(DateTime)> get _inPred => _predStateController.sink;

  Stream<bool Function(DateTime)> get pred => _predStateController.stream;

  CalendarPageBloc({thoughts}) {
    _thoughts = thoughts;
    _timeSeriesChart =
        new TimeSeriesChart(GetChartsData(_thoughts, DateTime.now()));
    _timeSeriesChart.createState();
    _inPred.add(isRightDay);
    _inTimeSeriesCharts.add(_timeSeriesChart);
    _chartsEventController.stream.listen(_updateCharts);
    _startDayStatisticPageController.stream.listen(_startDayStatisticPage);
  }

  void _startDayStatisticPage(DayStaticsticEvent event) {
    Navigator.push(event.context, MaterialPageRoute(builder: (context) {
      if (!_thoughts.containsKey(event.dateTime))
        _thoughts[event.dateTime] =
            new BaseData(event.dateTime, new List<String>(), 0);

      if (_thoughts[event.dateTime].thoughts == null)
        _thoughts[event.dateTime].thoughts = new List<String>();
      if (_thoughts[event.dateTime].mark == null)
        _thoughts[event.dateTime].mark = 0;
      return DayInformationWidget(event.dateTime,
          _thoughts[event.dateTime].thoughts, _thoughts[event.dateTime].mark);
    }));
  }

  void _updateCharts(UpdateChartsEvent event) {
    List l = GetChartsData(_thoughts, event.val);
    _timeSeriesChart.ts.updateCharts(l);
    _timeSeriesChart.ts.setState(() {});
    _inTimeSeriesCharts.add(_timeSeriesChart);
  }

  List<charts.Series<TimeSeriesSales, DateTime>> GetChartsData(
      Map<DateTime, BaseData> map, DateTime day) {
    List<TimeSeriesSales> res = [];
    map.keys.forEach((element) {
      if (element.year == day.year && element.month == day.month)
        if (map[element].mark >=0) {
          res.add(new TimeSeriesSales(element, map[element].mark));
        }
    });
    print(res.length);
    if (res.length == 0) {
      res.add(new TimeSeriesSales(new DateTime(day.year, day.month, 1), 0));
      res.add(new TimeSeriesSales(new DateTime(day.year, day.month, 28), 0));
    }
    return [
      new charts.Series(
          id: 'Sales',
          data: res,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales)
    ];
  }

  bool isRightDay(DateTime a) {
    DateTime date = DateTime.now();
    DateTime d1 = new DateTime(a.year, a.month, a.day);
    DateTime d2 = new DateTime(date.year, date.month, date.day);

    if (_thoughts.containsKey(a) || d1.compareTo(d2) == 0)
      return true;
    else
      return false;
  }

  void dispose() {
    _chartsEventController.close();
    _chartsStateController.close();
    _startDayStatisticPageController.close();
    _predStateController.close();
  }
}
