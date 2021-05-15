import 'dart:collection';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/Types/FriendsData.dart';
import 'package:mind_tracker/settings/settings_button_logic.dart';
import 'package:mind_tracker/share/share_bloc.dart';



class RequestScreen extends StatelessWidget {

  final List<String> friends = ["Friend1", "Friend2", "Friend3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friends"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(),
          ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(friends[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}
