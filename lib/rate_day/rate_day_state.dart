part of 'rate_day_bloc.dart';

abstract class RateDayState extends Equatable {
  const RateDayState();
  @override
  List<Object> get props => [];
}

class RateDayLoading extends RateDayState {
  @override
  List<Object> get props => [];
}
class RateDayLoaded extends RateDayState{
  final List<String> thoughts;
  final String mark;
  RateDayLoaded(this.thoughts, this.mark);
  @override
  List<Object> get props => [thoughts];
}
class RateDayTrashState extends RateDayState{

}