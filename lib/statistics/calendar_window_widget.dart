import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

import 'calendar_bloc.dart';
import 'calendar_data_events.dart';
import 'calendar_data_states.dart';
import 'calendat_states.dart';
import 'windowBloc.dart';

class CalendarWindowWidgetWrapper extends StatefulWidget {
  @override
  _CalendarWindowWidgetWrapperState createState() =>
      _CalendarWindowWidgetWrapperState();
}

class _CalendarWindowWidgetWrapperState
    extends State<CalendarWindowWidgetWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WindowBloc>(
      create: (context) {
        return WindowBloc()..add(GeneratePageEvent.loaded);
      },
      child: BlocBuilder<WindowBloc, CalendarStates>(
        builder: (context, state) {
          if (state is CalendarLoaded) {
            return CalendarWindowWidget(thoughts: state.thoughts);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class CalendarWindowWidget extends StatefulWidget {
  final Map<DateTime, BaseData> thoughts;

  const CalendarWindowWidget({Key key, this.thoughts}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CalendarWindowWidgetState(thoughts);
  }
}

class CalendarWindowWidgetState extends State<CalendarWindowWidget> {
  Map<DateTime, BaseData> thoughts = Map<DateTime, BaseData>();
  TimeSeriesChart timeSeriesChart;

  CalendarWindowWidgetState(this.thoughts) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: BlocProvider<CalendarBloc>(
              create: (context) {
                return CalendarBloc(thoughts: thoughts)..add(FirstDataEvent());
              },
              child: BlocBuilder<CalendarBloc, CalendarDataStates>(
                builder: (context, state) {
                  if (state is FirstCreationData) {
                    // ignore: missing_return
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 12,
                            child: CalendarDatePicker(
                              initialDate: DateTime.now(),
                              firstDate: new DateTime(DateTime.now().year,
                                  DateTime.now().month - 10, 1),
                              lastDate: new DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day),
                              onDateChanged: (value) => {
                                context.read<CalendarBloc>().add(
                                    DayStatisticEvent(
                                        context: context, dateTime: value))
                              },
                              selectableDayPredicate: state.isRightDay,
                              currentDate: DateTime.now(),
                              initialCalendarMode: DatePickerMode.day,
                              onDisplayedMonthChanged: (value) => {
                                context.read<CalendarBloc>().add(
                                    DayStatisticEvent(
                                        context: context, dateTime: value))
                              },
                            )),
                        Expanded(
                            flex: 10,
                            child: new Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: state.timeSeriesChart))
                      ], //children
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )));
  }

}
