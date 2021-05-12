part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();
}
class ShareLoad extends ShareEvent{
  final SplayTreeMap<DateTime, List<FriendsData>> friends;
  ShareLoad(this.friends);
  @override
  // TODO: implement props
  List<Object> get props => [friends];
}
class ShareLoadNoFriends extends ShareEvent{
  @override
  // TODO: implement props
  List<Object> get props =>[];

}
class ShareInit extends ShareEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ShareAddFriend extends ShareEvent{
  final String friendEmail;
  ShareAddFriend(this.friendEmail);
  @override
  // TODO: implement props
  List<Object> get props => [friendEmail];
}
