///Правый экрас с возможностью поделиться и записями друзей

import 'package:flutter/material.dart';

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
  final _friends = [
    'Friend1',
    'Friend2',
    'Friend3',
    'Friend4',
    'Friend5',
    'Friend6',
    'Friend7',
    'Friend8',
    'Friend9',
    'Friend10',
    'Friend11',
    'Friend12'
  ];
  final _moods = [10, 4, 3, 10, 2, 4, 1, 7, 2, 9, 1, 10];
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
                onPressed:() => {
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(content: new Text("Opening camera (no)")))
                },),
              IconButton(
                onPressed: () => {
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(content: new Text("Creating QR-CODE (no)")))
                },
                color: Colors.black,
                icon: Icon(Icons.qr_code_outlined),
                iconSize: 40,
              )
            ]),
        body: _buildList());
  }

  Widget _buildList() {
    int c = 0; //Счётчик вывода дат
    return ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: _friends.length + 3,
        itemBuilder: (context, i) {
          final index = i - c;
          if (i % 5 == 0) {
            //Вывод даты
            c += 1;
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF9FF),
                    //border: Border.all(color: Color(0xFF736CED), width: 1),
                    //borderRadius: BorderRadius.circular(7)
                  ),
                  child: ListTile(
                    title: Text('Date (last visited)', style: _dateFont),
                  )),
            );
          }
          return _buildRow(_friends[index], _moods[index]);
        });
  }

  Widget _buildRow(String text, int mood) {
    Icon i;
    switch (mood) {
      case 1:
        i = Icon(Icons.thumb_down,color: Colors.deepPurple);
        break;
      case 2:
        i = Icon(Icons.thumb_down,color: Colors.deepPurple);
        break;
      case 3:
        i = Icon(Icons.thumb_down,color: Colors.deepPurple);
        break;
      case 4:
        i = Icon(Icons.check,color: Colors.deepPurple);
        break;
      case 5:
        i = Icon(Icons.check,color: Colors.deepPurple);
        break;
      case 6:
        i = Icon(Icons.check,color: Colors.deepPurple);
        break;
      case 7:
        i = Icon(Icons.check,color: Colors.deepPurple);
        break;
      case 8:
        i = Icon(Icons.thumb_up,color: Colors.deepPurple);
        break;
      case 9:
        i = Icon(Icons.thumb_up,color: Colors.deepPurple);
        break;
      case 10:
        i = Icon(Icons.thumb_up,color: Colors.deepPurple);
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
}
