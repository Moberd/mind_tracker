part of 'rate_day_bloc.dart';

abstract class RateDayEvent extends Equatable {
  const RateDayEvent();
}
class RateDayLoad extends RateDayEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class RateDayAdd extends RateDayEvent{
  final String thought;
  final List<String> thoughts;
  RateDayAdd(this.thought, this.thoughts);
  @override
  // TODO: implement props
  List<Object> get props => [thought];

}
class RateDayDelete extends RateDayEvent{
  final int index;
  final List<String> thoughts;
  RateDayDelete(this.index, this.thoughts);
  @override
  // TODO: implement props
  List<Object> get props => [index];
}
class RateDaySetMark extends RateDayEvent{
  final int mark;
  RateDaySetMark(this.mark,);

  @override
  // TODO: implement props
  List<Object> get props => [mark];
}
class RateDatSaveLastMark extends RateDayEvent{
  final int mark;
  RateDatSaveLastMark(this.mark);

  @override
  // TODO: implement props
  List<Object> get props => [mark];
}
