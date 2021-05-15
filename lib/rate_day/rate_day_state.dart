part of 'rate_day_bloc.dart';

abstract class RateDayState {
  const RateDayState();

}

class RateDayLoading extends RateDayState {

}
class RateDayLoaded extends RateDayState{
  final List<String> thoughts;
  final String mark;
  RateDayLoaded(this.thoughts, this.mark);

}
class RateDayTrashState extends RateDayState{

}