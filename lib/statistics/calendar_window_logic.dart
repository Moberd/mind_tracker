

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/Types/BaseData.dart';

import 'calendar_window_widget.dart';

class GeneratePage{}

class CalendarBloc {
  final StreamController<Widget> _wigetStateController = new StreamController<
      Widget>();

  Stream<Widget> get calendarPage => _wigetStateController.stream;

  StreamSink<Widget> get _inCalendarPage => _wigetStateController.sink;
  final _widgetEventController = StreamController<GeneratePage>();
  Sink<GeneratePage> get pageGenerateEventSink => _widgetEventController.sink;

  CalendarBloc() {
    _widgetEventController.stream.listen(_calendarPageCreate);
    this.pageGenerateEventSink.add(new GeneratePage());
  }

  void _calendarPageCreate(GeneratePage event) {
    Widget page;
    String email = FirebaseAuth.instance.currentUser.email;
    page = new FutureBuilder<QuerySnapshot>(
      future:FirebaseFirestore.instance.collection("users").doc(email).collection("days").get(),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        print(snapshot);
        if(snapshot == null) {
          print("just null");
          return new Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data==null){
          print("data null");
          return new Center(child: CircularProgressIndicator(),);
        }
        Map<DateTime,BaseData> thoughts = {};
        for(DocumentSnapshot doc in snapshot.data.docs){
          final ddMMyyyy= doc.id.split("-");
          final int mark =  (doc.data()["mark"]??-1);
          List<String> thoughtsLst;
          try {
            thoughtsLst = new List<String>.from(
                doc.data()["thoughts"]);
          }catch(e){
            thoughtsLst = [];
          }
          final date = new DateTime(int.parse(ddMMyyyy[2]),int.parse(ddMMyyyy[1]),int.parse(ddMMyyyy[0]));
          thoughts[date] = new BaseData(date, thoughtsLst, mark);
        }
        print(thoughts);
        return CalendarWindowWidget(thoughts: thoughts,);
      } ,
    );
    _inCalendarPage.add(page);
  }

  void dispose() {
    _wigetStateController.close();
    _widgetEventController.close();
  }

}
