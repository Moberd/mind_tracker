part of 'share_bloc.dart';

abstract class ShareState extends Equatable {
  const ShareState();
}

class ShareLoading extends ShareState {
  @override
  List<Object> get props => [];
}
class ShareLoaded extends ShareState{
  final SplayTreeMap<DateTime, List<FriendsData>> friends;
  final String name;
  ShareLoaded(this.friends, this.name);
  @override
  // TODO: implement props
  List<Object> get props => [friends];
}
class ShareTrashState extends ShareState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class ShareLoadedNoFriends extends ShareState{
  final String name;

  ShareLoadedNoFriends(this.name);
  @override
  // TODO: implement props
  List<Object> get props => [name];

}
