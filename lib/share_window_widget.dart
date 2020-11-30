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
  final _dateFont =
      TextStyle(fontSize: 24.0, color: Colors.deepPurple);
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          title: Text('Your Name', style: _titleFont),
          actions: <Widget>[
            IconButton(
              onPressed: () => {
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text("Creating QR-CODE (no)")))
              },
              color: Colors.black,
              icon: const Icon(Icons.qr_code_outlined),
              iconSize: 40,
            ),
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
              padding: const EdgeInsets.only(left: 1,right:1),
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF9FF),
                    border: Border.all(color: Colors.black,width: 1),
                  ),
                  child: ListTile(
                    title: Text('Date', style: _dateFont),
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
        i = Icon(Icons.thumb_down);
        break;
      case 2:
        i = Icon(Icons.thumb_down);
        break;
      case 3:
        i = Icon(Icons.thumb_down);
        break;
      case 4:
        i = Icon(Icons.check);
        break;
      case 5:
        i = Icon(Icons.check);
        break;
      case 6:
        i = Icon(Icons.check);
        break;
      case 7:
        i = Icon(Icons.check);
        break;
      case 8:
        i = Icon(Icons.thumb_up);
        break;
      case 9:
        i = Icon(Icons.thumb_up);
        break;
      case 10:
        i = Icon(Icons.thumb_up);
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

