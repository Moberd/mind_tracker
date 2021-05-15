
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';
import 'calendar_data_states.dart';
import 'calendar_data_events.dart';
import 'day_information_widget.dart';

class CalendarBloc extends Bloc<CalendarDataEvents,CalendarDataStates>
{
  Map<DateTime, BaseData> _thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart _timeSeriesChart;
  CalendarBloc({thoughts}) : super(CalendarDataUpdating()){
    _thoughts = thoughts;
    _timeSeriesChart =
    new TimeSeriesChart(GetChartsData(_thoughts, DateTime.now()));
    _timeSeriesChart.createState();
  }

  @override
  Stream<CalendarDataStates> mapEventToState(CalendarDataEvents event) async* {
    if( event is UpdateChartsEvent)
      {
        List l = GetChartsData(_thoughts, event.val);
        _timeSeriesChart.ts.updateCharts(l);
        _timeSeriesChart.ts.setState(() {});
        yield FirstCreationData(_isRightDay,_timeSeriesChart);
      }
    else
      {
        if(event is DayStatisticEvent)
          {
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
            yield FirstCreationData(_isRightDay,_timeSeriesChart);
          }
        else
          {
            yield FirstCreationData(_isRightDay,_timeSeriesChart);
          }
      }
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

  bool _isRightDay(DateTime a) {
    DateTime date = DateTime.now();
    DateTime d1 = new DateTime(a.year, a.month, a.day);
    DateTime d2 = new DateTime(date.year, date.month, date.day);

    if (_thoughts.containsKey(a) || d1.compareTo(d2) == 0)
      return true;
    else
      return false;
  }
}
