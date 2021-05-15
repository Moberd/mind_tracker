import 'package:flutter/cupertino.dart';

abstract class CalendarDataEvents{
  const CalendarDataEvents();
}
class UpdateChartsEvent extends CalendarDataEvents
{
  DateTime val;

  UpdateChartsEvent({this.val});
}
class DayStatisticEvent extends CalendarDataEvents {
  BuildContext context;
  DateTime dateTime;

  DayStatisticEvent({this.context, this.dateTime});
}

class FirstDataEvent extends CalendarDataEvents{}