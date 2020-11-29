import 'package:charts_flutter/flutter.dart' as charts;

///правый экран с календарем и статистикой
import 'package:flutter/material.dart';

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
      MaterialPageRoute(builder: (context) => DayStatisticPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        body: new Padding(
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: [
              Flexible(
                flex: 2,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: _beginningOfCalendar,
                  lastDate: _endingOfCalendar,
                  onDateChanged: (value) => {startDayStatisticPage(context)},

                  /// selectableDayPredicate: _isEven,
                  currentDate: DateTime.now(),
                  initialCalendarMode: DatePickerMode.day,
                ),
              ),
              Flexible(
                  flex: 1,
                  child: new Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: new SimpleTimeSeriesChart.withSampleData()))
            ], //children
          ),
        ));
  }
}

//TODO Проработать отображение страницы с дневной информацией
class DayStatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: new SimpleTimeSeriesChart.withSampleData(),
      ),
    );
  }
}

///Функция используется как демонстрация и в будущем должна быть заменена на функцию, возвращающую, имеются ли записи за день

//TODO Исправить код генерации графика
//TODO Исправить отображение графика

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData2() {
    return new SimpleTimeSeriesChart(
      _createSampleData2(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData2() {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 11, 19), 7),
      new TimeSeriesSales(new DateTime(2020, 11, 26), 5),
      new TimeSeriesSales(new DateTime(2020, 11, 3), 10),
      new TimeSeriesSales(new DateTime(2020, 11, 10), 4),
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

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
