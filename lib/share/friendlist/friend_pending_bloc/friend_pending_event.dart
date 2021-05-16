part of 'friend_pending_bloc.dart';

@immutable
abstract class FriendPendingEvent {
}

class AddFriendEvent extends FriendPendingEvent{
  final String email;

  AddFriendEvent(this.email);
}
class DeleteFriendEvent extends FriendPendingEvent{
  final String email;

  DeleteFriendEvent(this.email);
}
class AcceptFriendRequestEvent extends FriendPendingEvent{
  final String email;

  AcceptFriendRequestEvent(this.email);
}
class DeclineFriendRequestEvent extends FriendPendingEvent{
  final String email;

  DeclineFriendRequestEvent(this.email,);
}
class LoadPendingEvent extends FriendPendingEvent{}
class LoadAddedEvent extends FriendPendingEvent{}

