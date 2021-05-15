import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_tracker/Types/BaseData.dart';

import 'calendat_states.dart';

///Генератор первоначальных данных
enum GeneratePageEvent { wait, loaded }

class WindowBloc extends Bloc<GeneratePageEvent, CalendarStates> {
  WindowBloc() : super(CalendarLoading());

  @override
  Stream<CalendarStates> mapEventToState(GeneratePageEvent event) async* {
    if (event == GeneratePageEvent.wait)
      yield CalendarLoading();
    else {
      String email = FirebaseAuth.instance.currentUser.email;
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .collection("days")
          .get();
      Map<DateTime, BaseData> thoughts = {};
      if (snapshot == null) {
        print("just null");
        yield CalendarLoading();
      }
      if (snapshot.docs == null) {
        print("data null");
        yield CalendarLoading();
      }
      for (DocumentSnapshot doc in snapshot.docs) {
        final ddMMyyyy = doc.id.split("-");
        final int mark = (doc.data()["mark"] ?? -1);
        List<String> thoughtsLst;
        try {
          thoughtsLst = new List<String>.from(doc.data()["thoughts"]);
        } catch (e) {
          thoughtsLst = [];
        }
        final date = new DateTime(int.parse(ddMMyyyy[2]),
            int.parse(ddMMyyyy[1]), int.parse(ddMMyyyy[0]));
        thoughts[date] = new BaseData(date, thoughtsLst, mark);
      }
      print(thoughts);
      yield CalendarLoaded(thoughts);
    }
  }
}
