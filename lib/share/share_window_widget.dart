import 'dart:collection';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/Types/FriendsData.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/authorization/authorization_window_widget.dart';
import 'package:mind_tracker/main.dart';
import 'package:mind_tracker/settings/settings_button_logic.dart';
import 'package:mind_tracker/share/friendlist/friend_list_widget.dart';
import 'package:mind_tracker/share/share_bloc.dart';
class FriendsList extends StatefulWidget {
  const FriendsList({Key key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final SettingButtonBloc _bloc = new SettingButtonBloc();
  final _titleFont =
      TextStyle(fontSize: 30.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _mainFont =
      TextStyle(fontSize: 24.0, color: Color.fromRGBO(0, 0, 0, 1));
  final _dateFont = TextStyle(fontSize: 24.0, color: Colors.deepPurple);
  int _initial = 0;

  Widget build(BuildContext context) {
    final blocEmail = BlocProvider.of<AuthBloc>(context).email;
    return BlocProvider<ShareBloc>(
      create: (context) {
        return ShareBloc(blocEmail)..add(ShareInit());
      },
      child: BlocBuilder<ShareBloc, ShareState>(
        builder: (context, state) {
          if (state is ShareLoaded) {
            if(kIsWeb){
              return Scaffold(
                  backgroundColor: Color(0xFFFEF9FF),
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: 60,
                      backgroundColor: Colors.white,
                      title: Text(state.name, style: _titleFont),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.black,
                          iconSize: 40,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()),(Route<dynamic> route) => false,);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person_search),
                          color: Colors.black,
                          iconSize: 40,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendListWindow())),
                        ),
                      ]),
                  body: _buildList(state.friends));
            }
            return Scaffold(
                backgroundColor: Color(0xFFFEF9FF),
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 60,
                    backgroundColor: Colors.white,
                    title: Text(state.name, style: _titleFont),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.settings),
                        color: Colors.black,
                        iconSize: 40,
                        onPressed: () => {
                          _bloc.statisticPageEventSink
                              .add(new StartSettingsPageEvent(context: context))
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_search),
                        color: Colors.black,
                        iconSize: 40,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendListWindow())),
                      ),
                    ]),
                body: _buildList(state.friends));
          }
          if (state is ShareLoadedNoFriends) {
            if(kIsWeb){
              return Scaffold(
                  backgroundColor: Color(0xFFFEF9FF),
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: 60,
                      backgroundColor: Colors.white,
                      title: Text(state.name, style: _titleFont),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.black,
                          iconSize: 40,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()),(Route<dynamic> route) => false,);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person_search),
                          color: Colors.black,
                          iconSize: 40,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendListWindow())),
                        ),
                      ]),
                  body: Center(
                      child: Text(
                        Strings.useQRToAddNewFriends[lang],
                        style: _mainFont,
                        textAlign: TextAlign.center,
                      )));
            }
            return Scaffold(
                backgroundColor: Color(0xFFFEF9FF),
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 60,
                    backgroundColor: Colors.white,
                    title: Text(state.name, style: _titleFont),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.settings),
                        color: Colors.black,
                        iconSize: 40,
                        onPressed: () => {
                          _bloc.statisticPageEventSink
                              .add(new StartSettingsPageEvent(context: context))
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_search),
                        color: Colors.black,
                        iconSize: 40,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendListWindow())),
                      ),
                    ]),
                body: Center(
                    child: Text(
                  Strings.useQRToAddNewFriends[lang],
                  style: _mainFont,
                  textAlign: TextAlign.center,
                )));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  AppBar genAppBar(ShareState state){
    return AppBar(
    );
  }
  Widget _buildList(SplayTreeMap<DateTime, List<FriendsData>> map) {
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
                    title: Text(Strings.lastVisit[lang] + formatted,
                        style: _dateFont)),
                subtitle: FutureBuilder<Widget>(
                  initialData: Center(
                    child: CircularProgressIndicator(),
                  ),
                  future: _buildRows(map[map.keys.elementAt(i)]),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    return snapshot.data;
                  },
                ),
              ));
        });
  }

  Future<Widget> _buildRows(List<FriendsData> list) async {
    print(list.toString());
    print("--------------------------");
    Widget widget = ExpansionPanelList.radio(
      animationDuration: Duration(milliseconds: 500),
      elevation: 1,
      children: _buildPanels(list),
    );
    return widget == null ? Text("Привет") : widget;
  }

  List<ExpansionPanelRadio> _buildPanels(List<FriendsData> list) {
    print("building");
    var l = List<ExpansionPanelRadio>.generate(list.length, (index) {
      return buildFriendTile(list[index], index);
    });
    print(l == null);
    return l;
  }

  ExpansionPanelRadio buildFriendTile(FriendsData friend, int index) {
    Icon i;
    switch ((friend.mood / 100).round()) {
      case 0:
        i = Icon(Icons.mood_bad_outlined, color: Colors.deepPurple);
        break;
      case 1:
        i = Icon(Icons.filter_1_outlined, color: Colors.deepPurple);
        break;
      case 2:
        i = Icon(Icons.filter_2_outlined, color: Colors.deepPurple);
        break;
      case 3:
        i = Icon(Icons.filter_3_outlined, color: Colors.deepPurple);
        break;
      case 4:
        i = Icon(Icons.filter_4_outlined, color: Colors.deepPurple);
        break;
      case 5:
        i = Icon(Icons.filter_5_outlined, color: Colors.deepPurple);
        break;
      case 6:
        i = Icon(Icons.filter_6_outlined, color: Colors.deepPurple);
        break;
      case 7:
        i = Icon(Icons.filter_7_outlined, color: Colors.deepPurple);
        break;
      case 8:
        i = Icon(Icons.filter_8_outlined, color: Colors.deepPurple);
        break;
      case 9:
        i = Icon(Icons.filter_9_outlined, color: Colors.deepPurple);
        break;
      case 10:
        i = Icon(Icons.mood_outlined, color: Colors.deepPurple);
        break;
      default:
    }
    var w = ExpansionPanelRadio(
        value: index,
        headerBuilder: (context, isExpanded) {
          return ListTile(
            title: Text(
              friend.friendName,
              style: _mainFont,
            ),
            trailing: i,
          );
        },
        body: friend.timeSeriesChart == null
            ? Container(
                width: 0.0,
                height: 0.0,
              )
            : Container(
                width: 300.0,
                height: 300.0,
                child: friend.timeSeriesChart,
              )
    );
    return w;
  }

  Future scan(BuildContext context) async {
    try {
      var result = await BarcodeScanner.scan();
      BlocProvider.of<ShareBloc>(context).add(ShareAddFriend(result));
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
}
