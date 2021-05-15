

import 'package:mind_tracker/Types/BaseData.dart';

abstract class CalendarStates {
  const CalendarStates();

}

class CalendarLoading extends CalendarStates {

}

class CalendarLoaded extends CalendarStates{
  final Map<DateTime,BaseData> thoughts;

  CalendarLoaded(this.thoughts);
}