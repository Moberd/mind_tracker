import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  TimeSeriesChartState ts;

  TimeSeriesChart(this.seriesList, {this.animate});

  @override
  State<StatefulWidget> createState() {
    ts = new TimeSeriesChartState(seriesList, animate: animate);
    return ts;
  }

  factory TimeSeriesChart.withSampleData() {
    return new TimeSeriesChart(_createSimpleData(), animate: false);
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSimpleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 11, 3), 10),
      new TimeSeriesSales(new DateTime(2020, 11, 10), 4),
      new TimeSeriesSales(new DateTime(2020, 11, 19), 7),
      new TimeSeriesSales(new DateTime(2020, 11, 26), 5),
    ];

    return [
      new charts.Series(
          id: 'Sales',
          data: data,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales)
    ];
  }
}

///Котейнер для сериализации данных
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class TimeSeriesChartState extends State<TimeSeriesChart> {
  List<charts.Series> seriesList;
  bool animate;

  ///Обновление графика
  void updateCharts(List<charts.Series> list){
    seriesList = list;
  }

  TimeSeriesChartState(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        animate: animate, dateTimeFactory: const charts.LocalDateTimeFactory());
  }

  @override
  void initState() {
    super.initState();
  }

}
