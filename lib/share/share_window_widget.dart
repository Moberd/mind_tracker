import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:mind_tracker/share/generate_qr.dart';

class ShareWindowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FriendsList(),
    );
  }
}

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final _titleFont =
      TextStyle(fontSize: 30.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _mainFont =
      TextStyle(fontSize: 24.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _dateFont = TextStyle(fontSize: 24.0, color: Colors.deepPurple);
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            title: Text('Your Name', style: _titleFont),
            actions: <Widget>[
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
  
  List<dynamic> friends;
  void getData(){
    var mEmail = FirebaseAuth.instance.currentUser.email;
    FirebaseFirestore.instance.collection('users').doc(mEmail).get().then((value) {
      friends = value.data()["friends"];
    });
  }
  Widget _buildList() {
    /*return ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: _friends.length,
        itemBuilder: (context, i) {
          //тут дата
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF9FF),
                  ),
                  child: ListTile(
                    title: Text('Date (last visited)', style: _dateFont),
                  )),
            );
          }
          //тут друг
          return _buildRow(_friends[index], _moods[index]);
        });*/
  }

  Widget _buildRow(String text, int mood) {
    Icon i;
    switch (mood) {
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
          text,
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
    var mEmail = FirebaseAuth.instance.currentUser.email;
    FirebaseFirestore.instance
        .collection('users')
        .doc(mEmail)
        .get()
        .then((value) {
      List<dynamic> list = value.data()["friends"];
      list.add(name);
      applyChanges(list);
    });
  }

  void applyChanges(List<dynamic> friendsList) {
    var mEmail = FirebaseAuth.instance.currentUser.email;
    FirebaseFirestore.instance
        .collection('users')
        .doc(mEmail)
        .update({"friends": friendsList});
  }
}
