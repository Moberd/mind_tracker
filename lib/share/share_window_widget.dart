import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/Types/FriendsData.dart';
import 'package:mind_tracker/settings_button_logic.dart';
import 'package:mind_tracker/share/generate_qr.dart';

class FriendListWrapper extends StatefulWidget {
  @override
  _FriendListWrapperState createState() => _FriendListWrapperState();
}

class _FriendListWrapperState extends State<FriendListWrapper> {
  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser.email;
    return new StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users_friends")
          .doc(email)
          .snapshots(),
      builder: (context, myDoc) {
        if (myDoc == null)
          return new Center(
            child: CircularProgressIndicator(),
          );
        if (myDoc.data == null)
          return new Center(
            child: CircularProgressIndicator(),
          );
        if (myDoc.data.data() == null)
          return new Center(
            child: CircularProgressIndicator(),
          );
        String userName = myDoc.data.data()["name"];
        return new FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("users_friends")
              .where("friends", arrayContainsAny: [email]).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            List<FriendsData> data = [];
            for (DocumentSnapshot doc in snapshot.data.docs) {
              if (doc.data()["lastmark"] == "") {
                data.add(new FriendsData("01-01-1969", doc.data()["name"], 5));
              } else {
                data.add(new FriendsData(doc.data()["lastvisited"],
                    doc.data()["name"], doc.data()["lastmark"]));
              }
            }
            return FriendsList(
              userName: userName,
              data: data,
            );
          },
        );
      },
    );
  }
}

class FriendsList extends StatefulWidget {
  
  
  final String userName;
  final List<FriendsData> data;

  const FriendsList({Key key, this.userName, this.data}) : super(key: key);
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {

  final SettingButtonBloc _bloc = new SettingButtonBloc();
  final _titleFont =
      TextStyle(fontSize: 30.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _mainFont =
      TextStyle(fontSize: 24.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _dateFont = TextStyle(fontSize: 28.0, color: Colors.deepPurple);
  
  SplayTreeMap<DateTime, List<FriendsData>> generateMap() {
    SplayTreeMap<DateTime, List<FriendsData>> result =
        SplayTreeMap<DateTime, List<FriendsData>>((a, b) {
      return a.compareTo(b) * (-1);
    });
    final data = widget.data;
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

  Widget build(BuildContext context) {
    if (widget.data.isEmpty)
      return Scaffold(
          backgroundColor: Color(0xFFFEF9FF),
          appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: Colors.white,
              title: Text('${widget.userName}', style: _titleFont),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  color: Colors.black,
                  iconSize: 40,
                  onPressed: () => {scan()},
                ),
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenerateScreen()))
                  },
                  color: Colors.black,
                  icon: Icon(Icons.qr_code_outlined),
                  iconSize: 40,
                )
              ]),
          body: Center(
              child: Text(
            "Use QR to add new friends",
            style: _mainFont,
          )));
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.white,
            title: Text('${widget.userName}', style: _titleFont),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                color: Colors.black,
                iconSize: 40,
                onPressed: () => {_bloc.statisticPageEventSink.add(new StartSettingsPageEvent(context: context))},
              ),
              IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                color: Colors.black,
                iconSize: 40,
                onPressed: () => {scan()},
              ),
              IconButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GenerateScreen()))
                },
                color: Colors.black,
                icon: Icon(Icons.qr_code_outlined),
                iconSize: 40,
              )
            ]),
        body: _buildList());
  }

  Widget _buildList() {
    var map = generateMap();
    return ListView.builder(
        itemCount: map.length,
        itemBuilder: (context, i) {
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          final String formatted = formatter.format(map.keys.elementAt(i));
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFFEF9FF),
            ),
            child: ListTile(
                title: ListTile(
                    title: Text(
                        'Last visit on $formatted',
                        style: _dateFont)),
                subtitle: _buildRows(map[map.keys.elementAt(i)])),
          );
        });
  }

  Widget _buildRows(List<FriendsData> list) {
    print(list.toString());
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, i) {
          return buildFriendTile(list[i]);
        });
  }

  Widget buildFriendTile(FriendsData friend) {
    Icon i;
    switch (friend.mood) {
      case 0:
        i = Icon(Icons.thumb_down, color: Colors.deepPurple);
        break;
      case 1:
        i = Icon(Icons.thumb_down, color: Colors.deepPurple);
        break;
      case 2:
        i = Icon(Icons.thumb_down, color: Colors.deepPurple);
        break;
      case 3:
        i = Icon(Icons.thumb_down, color: Colors.deepPurple);
        break;
      case 4:
        i = Icon(Icons.check, color: Colors.deepPurple);
        break;
      case 5:
        i = Icon(Icons.check, color: Colors.deepPurple);
        break;
      case 6:
        i = Icon(Icons.check, color: Colors.deepPurple);
        break;
      case 7:
        i = Icon(Icons.check, color: Colors.deepPurple);
        break;
      case 8:
        i = Icon(Icons.thumb_up, color: Colors.deepPurple);
        break;
      case 9:
        i = Icon(Icons.thumb_up, color: Colors.deepPurple);
        break;
      case 10:
        i = Icon(Icons.thumb_up, color: Colors.deepPurple);
        break;
      default:
    }
    return Card(
      child: ListTile(
        title: Text(
          friend.friendName,
          style: _mainFont,
        ),
        trailing: i,
      ),
    );
  }

  Future scan() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() => {addFriend(result)});
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => {});
      } else {
        setState(() => {});
      }
    } on FormatException {
      setState(() => {});
    } catch (e) {
      setState(() => {});
    }
  }

  void addFriend(String name) async {
    final mEmail = FirebaseAuth.instance.currentUser.email;
    FirebaseFirestore.instance.collection("users_friends").doc(mEmail).update({
      "friends": FieldValue.arrayUnion([name])
    });
    FirebaseFirestore.instance.collection("users_friends").doc(name).update({
      "friends": FieldValue.arrayUnion([mEmail])
    });
  }
}
