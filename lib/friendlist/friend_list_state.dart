part of 'friend_list_bloc.dart';

abstract class FriendListState extends Equatable {
  const FriendListState();
}

class FriendListInitial extends FriendListState {
  @override
  List<Object> get props => [];
}
