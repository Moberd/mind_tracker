part of 'friend_pending_bloc.dart';

@immutable
abstract class FriendPendingState {}

class PendingLoadingState extends FriendPendingState{}
class AddedLoadingState extends FriendPendingState{}
class PendingLoadedState extends FriendPendingState{
  final List<String> emails;

  PendingLoadedState(this.emails);
}
class AddedLoadedState extends FriendPendingState{
  final List<String> emails;

  AddedLoadedState(this.emails);
}
