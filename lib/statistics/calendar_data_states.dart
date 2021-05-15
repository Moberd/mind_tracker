import 'package:mind_tracker/statistics/time_series_chart.dart';

abstract class CalendarDataStates{
  const CalendarDataStates();
}
class CalendarDataUpdating extends CalendarDataStates {

}

class CalendarDataUpdated extends CalendarDataStates{
  TimeSeriesChart timeSeriesChart;

  CalendarDataUpdated(this.timeSeriesChart);
}

class FirstCreationData extends CalendarDataStates{
  bool Function(DateTime) isRightDay;
  TimeSeriesChart timeSeriesChart;
  FirstCreationData(this.isRightDay, this.timeSeriesChart);
}