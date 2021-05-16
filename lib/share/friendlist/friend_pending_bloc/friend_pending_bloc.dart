import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'friend_pending_event.dart';
part 'friend_pending_state.dart';

class FriendPendingBloc extends Bloc<FriendPendingEvent, FriendPendingState> {
  FriendPendingBloc({@required String email,})
      :email = email, super(PendingLoadingState());
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
      final doc = fr.collection("users_friends").doc(event.email);
      final data = await doc.get();
      final pendingFriends = new List<String>.from(data.data()["pending"]??[]);
      final actualFriends =  new List<String>.from(data.data()["friends"]??[]);
      final stateBefore = state;
      if(actualFriends.contains(email)){
        yield ShowSnackBarState("You have already added this friend");
      }
      else if(pendingFriends.contains(email)){
        yield ShowSnackBarState("You have already sent friend request");
      }
      else{
        yield ShowSnackBarState("Friend request has been sent");
        doc.update({"pending":FieldValue.arrayUnion([email])});
      }
      yield stateBefore;
    }
    if(event is DeclineFriendRequestEvent){
      final doc =  fr.collection("users_friends").doc(email);
      await doc.update({"pending":FieldValue.arrayRemove([event.email])});
      add(LoadPendingEvent());
    }
    if(event is AcceptFriendRequestEvent){
      final doc = fr.collection("users_friends").doc(email);
      await doc.update({"pending":FieldValue.arrayRemove([event.email])});
      doc.update({"friends":FieldValue.arrayUnion([event.email])},);
      final friendDoc = fr.collection('users_friends').doc(event.email);
      friendDoc.update({"friends":FieldValue.arrayUnion([email])},);
      add(LoadPendingEvent());
    }
  }

}

