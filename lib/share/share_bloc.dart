import 'dart:async';
import 'dart:collection';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/Types/BaseData.dart';
import 'package:mind_tracker/Types/FriendsData.dart';
import 'package:mind_tracker/statistics/time_series_chart.dart';

part 'share_event.dart';

part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final String email;
  StreamSubscription streamSubscription;

  ShareBloc(this.email) : super(ShareLoading());
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  Map<String, List<int>> friendsMarks = new Map<String, List<int>>();

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    print(event);
    if (event is ShareInit) {
      yield* mapInitToState();
    }
    if (event is ShareLoad) {
      yield* mapLoadToState(event);
    }
    if (event is ShareLoadNoFriends) {
      final myDoc = await fr.collection("users_friends").doc(email).get();
      final name = myDoc.data()["name"];
      yield ShareLoadedNoFriends(name);
    }
    if (event is ShareAddFriend) {
      if (email != event.friendEmail) {
        fr.collection("users_friends").doc(email).update({
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
    final myDoc = await fr.collection("users_friends").doc(email).get();
    final name = myDoc.data()["name"];
    yield ShareLoaded(event.friends, name);
  }

  Stream<ShareState> mapInitToState() async* {
    streamSubscription?.cancel();

    streamSubscription = createStream().listen((future)async {
      final friendsList = await future;
      print(friendsList);
      if (friendsList.isEmpty) {
        add(ShareLoadNoFriends());
      } else {
        add(ShareLoad(generateMap(friendsList)));
      }
    });
  }

  Stream<Future<List<FriendsData>>> createStream() {
    final stream = fr
        .collection("users_friends")
        .where("friends", arrayContainsAny: [email])
        .snapshots()
        .map((snapshot)async {
      List<FriendsData> data = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc.data()["lastmark"] == "") {
          data.add(
              new FriendsData("01-01-1969", doc.data()["name"], 500, null));
        }
        else {
          print(doc.data());
          var snapshot = await fr
              .collection("users")
              .doc(doc.data()["id"])
              .collection("days")
              .get();
          TimeSeriesChart res = null;
          if (snapshot == null || snapshot.docs == null) {
            res = null;
          }
          else {
            Map<DateTime, BaseData> thoughts = {};
            for (DocumentSnapshot doc in snapshot.docs) {
              final ddMMyyyy = doc.id.split("-");
              final int mark = (doc.data()["mark"] ?? -1);
              final date = new DateTime(int.parse(ddMMyyyy[2]),
                  int.parse(ddMMyyyy[1]), int.parse(ddMMyyyy[0]));
              thoughts[date] = new BaseData(date, null, mark);
            }
            res = TimeSeriesChart(GetChartsData(thoughts, DateTime.now()));
            res.createState();
          }
          data.add(new FriendsData(doc.data()["lastvisited"],
              doc.data()["name"], doc.data()["lastmark"], res));
        }
      }
      return data;
    });
    return stream;
  }

  SplayTreeMap<DateTime, List<FriendsData>> generateMap(
      List<FriendsData> data) {
    SplayTreeMap<DateTime, List<FriendsData>> result =
        SplayTreeMap<DateTime, List<FriendsData>>((a, b) {
      return a.compareTo(b) * (-1);
    });
    for (var friend in data) {
      List<FriendsData> t = [];
      final date = new DateFormat("dd-MM-yyy").parse(friend.dates);
      if (result[date] != null) {
        t = result[date];
        t.add(new FriendsData(friend.dates, friend.friendName, friend.mood,
            friend.timeSeriesChart));
      } else {
        t.add(new FriendsData(friend.dates, friend.friendName, friend.mood,
            friend.timeSeriesChart));
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

  List<charts.Series<TimeSeriesSales, DateTime>> GetChartsData(
      Map<DateTime, BaseData> map, DateTime day) {
    List<TimeSeriesSales> res = [];
    map.keys.forEach((element) {
      if (element.year == day.year &&
          element.month == day.month) if (map[element].mark >= 0) {
        res.add(new TimeSeriesSales(element, map[element].mark));
      }
    });
    print(res.length);
    if (res.length == 0) {
      res.add(new TimeSeriesSales(new DateTime(day.year, day.month, 1), 0));
      res.add(new TimeSeriesSales(new DateTime(day.year, day.month, 28), 0));
    }
    return [
      new charts.Series(
          id: 'Sales',
          data: res,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales)
    ];
  }
}
