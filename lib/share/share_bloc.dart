import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/Types/FriendsData.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final String email;
  StreamSubscription streamSubscription;
  ShareBloc(this.email) : super(ShareLoading());
  final FirebaseFirestore fr = FirebaseFirestore.instance;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    print(event);
    if(event is ShareInit){
      yield* mapInitToState();
    }
    if(event is ShareLoad){
      yield* mapLoadToState(event);
    }
    if(event is ShareLoadNoFriends){
      final myDoc= await fr.collection("users_friends").doc(email).get();
      final name = myDoc.data()["name"];
      yield ShareLoadedNoFriends(name);
    }
    if(event is ShareAddFriend){
      if(email != event.friendEmail){
        fr.collection("users_friends").doc(email).update(   {
          "friends": FieldValue.arrayUnion([event.friendEmail])
        });
        fr.collection("users_friends").doc(event.friendEmail).update({
          "friends": FieldValue.arrayUnion([email])
        });
        yield ShareLoading();
        add(ShareInit());
      }
    }
  }
  Stream<ShareState> mapLoadToState(ShareLoad event) async* {
    print(event.friends);
    final myDoc= await fr.collection("users_friends").doc(email).get();
    final name = myDoc.data()["name"];
    yield ShareLoaded(event.friends, name);
  }
  Stream<ShareState> mapInitToState() async* {
    streamSubscription?.cancel();
    streamSubscription = createStream().listen((friendsList) {
      print(friendsList);
      if(friendsList.isEmpty){
        add(ShareLoadNoFriends());
      }
      else {
        add(ShareLoad(generateMap(friendsList)));
      }
    });
  }

  Stream<List<FriendsData>> createStream(){
    return fr.collection("users_friends").where("friends",arrayContainsAny: [email]).snapshots().map((snapshot){
      List<FriendsData> data = [];
      for(DocumentSnapshot  doc in snapshot.docs){
        if (doc.data()["lastmark"] == "") {
          data.add(new FriendsData("01-01-1969", doc.data()["name"], 500));
        } else {
          data.add(new FriendsData(doc.data()["lastvisited"],
              doc.data()["name"], doc.data()["lastmark"]));
        }
      }
      return data;
    });

  }
  SplayTreeMap<DateTime, List<FriendsData>> generateMap(List<FriendsData> data) {

    SplayTreeMap<DateTime, List<FriendsData>> result = SplayTreeMap<DateTime, List<FriendsData>>((a, b) {return a.compareTo(b) * (-1);});
    for (var friend in data) {
      List<FriendsData> t = [];
      final date = new DateFormat("dd-MM-yyy").parse(friend.dates);
      if (result[date] != null) {
        t = result[date];
        t.add(new FriendsData(friend.dates, friend.friendName, friend.mood));
      } else {
        t.add(new FriendsData(friend.dates, friend.friendName, friend.mood));
      }
      result[date] = t;
    }
    return result;
  }
  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }

}