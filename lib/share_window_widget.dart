///Правый экрас с возможностью поделиться и записями друзей


import 'package:flutter/material.dart';

class ShareWindowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FriendsList(),
    );
  }
}

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}
class _FriendsListState extends State<FriendsList> {
  final _friends = ['Friend1','Friend2','Friend3','Friend4', 'Friend5', 'Friend6', 'Friend7','Friend8','Friend9','Friend10', 'Friend11', 'Friend12'];
  final _moods = [5,4,3,5,2,3,1,4,2,3,1,1];
  final _titleFont = TextStyle(fontSize: 30.0, color : Color.fromRGBO(0, 0, 0, 1));
  final _mainFont = TextStyle(fontSize: 24.0, color : Color.fromRGBO(0, 0, 0, 1));
  final _dateFont = TextStyle(fontSize: 24.0, color: Color.fromRGBO(159, 159, 237, 1));
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            title: Text('Your Name', style : _titleFont),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                iconSize: 40,
              ),
            ]
        ),
        body: _buildList()
    );
  }

  Widget _buildList(){
    int c = 0; //Счётчик вывода дат
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _friends.length + 3,
        itemBuilder: (context, i) {
          final index = i - c;
          if (i % 5 == 0) { //Вывод даты
            c += 1;
            return Container (
                decoration: new BoxDecoration (
                  color: Color.fromRGBO(233,221,246,0.3),
                ),
                child: new ListTile (
                  title: Text('Date', style: _dateFont),
                )
            );
          }
          return _buildRow(_friends[index], _moods[index]);
        });
  }
  Widget _buildRow(String text, int mood) {
    return ListTile(
      title: Text(
        text,
        style: _mainFont,
      ),
      trailing: Icon(Icons.thumb_up),
    );
  }

}

