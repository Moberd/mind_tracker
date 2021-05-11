import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'rate_day_event.dart';
part 'rate_day_state.dart';

class RateDayBloc extends Bloc<RateDayEvent, RateDayState> {
  final String email;
  RateDayBloc(String em) :email = em, super(RateDayLoading());
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  @override
  Stream<RateDayState> mapEventToState(
    RateDayEvent event,
  ) async* {
    if(event is RateDayLoad){
      yield* _mapDayLoadToState();
    }
    if(event is RateDayAdd){
      yield* _mapAddToState(event);
    }
    if(event is RateDayDelete){
      yield* _mapDeleteToState(event);
    }
    if(event is RateDaySetMark){
      yield* _mapSetMarkToState(event);
    }
    if(event is RateDatSaveLastMark){
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      final ref = fr.collection("users").doc(email).collection("days").doc(formatted);
      ref.get().then((value){
        if(value.exists){
          ref.update({"mark":event.mark});
        }
        else{
          ref.set({"mark":event.mark});
        }
      });
    }
  }
    Stream<RateDayState> _mapDayLoadToState() async*{
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      final doc  = await fr.collection("users").doc(email).collection("days").doc(formatted).get();
      if(doc.data() == null){
        yield RateDayLoaded([],"5");
      }
      final thoughtList =  new List<String>.from(doc.data()["thoughts"]??[]);
      final mark =  (doc.data()["mark"]??5).toString();
      yield RateDayLoaded(thoughtList,mark);
  }

  Stream<RateDayState> _mapAddToState(RateDayAdd event) async* {
    List<String> thoughts = event.thoughts;
    thoughts.add(event.thought);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    final ref = fr.collection("users").doc(email).collection("days").doc(formatted);
    ref.get().then((value){
      if(value.exists){
        ref.update({"thoughts":thoughts});
      }
      else{
        ref.set({"thoughts":thoughts});
      }
    });

    yield RateDayTrashState();
    yield RateDayLoaded(thoughts,(state as RateDayLoaded).mark);
  }

  Stream<RateDayState> _mapDeleteToState(RateDayDelete event) async* {
    List<String> thoughts = event.thoughts;
    thoughts.removeAt(event.index);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    final ref = fr.collection("users").doc(email).collection("days").doc(formatted);
    ref.get().then((value){
      if(value.exists){
        ref.update({"thoughts":thoughts});
      }
      else{
        ref.set({"thoughts":thoughts});
      }
    });
    yield RateDayTrashState();
    yield RateDayLoaded(thoughts,(state as RateDayLoaded).mark);
  }

  Stream<RateDayState> _mapSetMarkToState(RateDaySetMark event)async*{
    yield RateDayTrashState();
    yield RateDayLoaded((state as RateDayLoaded).thoughts,event.mark.toString());
  }
}

