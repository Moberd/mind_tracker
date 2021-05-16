part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class StartSearchingEvent extends SearchEvent{
  final String pattern;

  StartSearchingEvent(this.pattern);

}
class AddFriendSearchEvent extends SearchEvent{
  final String email;

  AddFriendSearchEvent(this.email);
}
