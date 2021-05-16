import 'package:mind_tracker/statistics/time_series_chart.dart';

class FriendsData {
  String dates;
  String friendName;
  int mood;
  TimeSeriesChart timeSeriesChart;
  FriendsData(this.dates, this.friendName, this.mood, this.timeSeriesChart);
}