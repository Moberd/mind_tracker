import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'friend_list_event.dart';
part 'friend_list_state.dart';

class FriendListBloc extends Bloc<FriendListEvent, FriendListState> {
  FriendListBloc() : super(FriendListInitial());

  @override
  Stream<FriendListState> mapEventToState(
    FriendListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
