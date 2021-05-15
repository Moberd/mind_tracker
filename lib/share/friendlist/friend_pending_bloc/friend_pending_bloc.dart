import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'friend_pending_event.dart';
part 'friend_pending_state.dart';

class FriendPendingBloc extends Bloc<FriendPendingEvent, FriendPendingState> {
  FriendPendingBloc({String email}):email = email, super(PendingLoadingState());
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  final String email;

  @override
  Stream<FriendPendingState> mapEventToState(
    FriendPendingEvent event,
  ) async* {
    print(event);
    if(event is LoadAddedEvent){
      yield AddedLoadingState();
      final doc = await fr.collection("users_friends").doc(email).get();
      final addedFriends =  new List<String>.from(doc.data()["friends"]??[]);
      print(addedFriends);
      yield AddedLoadedState(addedFriends);
    }
    if(event is LoadPendingEvent){
      yield PendingLoadingState();
      final doc = await fr.collection("users_friends").doc(email).get();
      final pendingFriends =new List<String>.from( doc.data()["pending"]??[]);
      print(pendingFriends);
      yield PendingLoadedState(pendingFriends);
      }
    if(event is DeleteFriendEvent){
      final doc =  fr.collection("users_friends").doc(email);
      await doc.update({"friends":FieldValue.arrayRemove([event.email])});
      final friendDoc = fr.collection('users_friends').doc(event.email);
      friendDoc.update({"friends":FieldValue.arrayRemove([email])});
      add(LoadAddedEvent());
    }
    if(event is AddFriendEvent){
      print(event);
      final doc = fr.collection("users_friends").doc(event.email);
      await doc.update({"pending":FieldValue.arrayUnion([email])});
    }
  }

}

