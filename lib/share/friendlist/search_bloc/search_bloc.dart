import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(String email):email = email, super(SearchLoading());
  final String email;
  FirebaseFirestore fr = FirebaseFirestore.instance;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
      print(event);
      if(event is StartSearchingEvent){
        if(event.pattern.length>2){
        List<String> result =[];
        final strFrontCode = event.pattern.substring(0, event.pattern.length - 1);
        final strEndCode = event.pattern.runes.last;
        final limit =
            strFrontCode + String.fromCharCode(strEndCode + 1);
        final snap = await fr.collection('users_friends')
            .where('id', isGreaterThanOrEqualTo: event.pattern)
            .where('id', isLessThan: limit)
            .get();
        for(final doc in snap.docs){

          if(!((doc.data()["id"] as String) == email))
            result.add((doc.data()["id"]));
        }
          yield SearchLoaded(result);
        }
        else{
          yield SearchLoaded([]);
        }

      }
      if(event is AddFriendSearchEvent){
        final doc = fr.collection("users_friends").doc(event.email);
        final data = await doc.get();
        final pendingFriends = new List<String>.from(data.data()["pending"]??[]);
        final actualFriends =  new List<String>.from(data.data()["friends"]??[]);
        final stateBefore = state;
        if(actualFriends.contains(email)){
          yield ShowSnackBarSearchState("You have already added this friend");
        }
        else if(pendingFriends.contains(email)){
          yield ShowSnackBarSearchState("You have already sent friend request");
        }
        else{
          yield ShowSnackBarSearchState("Friend request has been sent");
          doc.update({"pending":FieldValue.arrayUnion([email])});
        }
        yield stateBefore;
      }
  }
}
