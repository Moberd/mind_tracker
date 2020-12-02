import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesChart(this.seriesList, {this.animate});

  factory TimeSeriesChart.withSampleData() {
    return new TimeSeriesChart(_createSimpleData(), animate: false);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        animate: animate, dateTimeFactory: const charts.LocalDateTimeFactory());
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
