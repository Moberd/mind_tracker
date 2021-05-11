import 'package:flutter/material.dart';
import 'package:mind_tracker/rate_day/main_window_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_tracker/settings/settings_logic.dart';
import '../rate_day/main_window_widget.dart';
import '../share/share_window_widget.dart';
import '../statistics/calendar_window_widget.dart';
import 'logic.dart';

SharedPreferences prefs;
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final _bloc = HomeBloc();


  @override
  void initState() {
    super.initState();
    getData();
  }



  getData() async {
    //Получение листа из памяти
    prefs = await SharedPreferences.getInstance();
    setState(() {
      thoughtsList = prefs.getStringList('thoughts_list') == null
          ? []
          : prefs.getStringList('thoughts_list');

      int hour = prefs.getInt("hours") == null? TimeOfDay.now().hour:prefs.getInt("hours");
      int minute = prefs.getInt("minute") == null? TimeOfDay.now().minute:prefs.getInt("minute");
      notificationTime =TimeOfDay(hour: hour, minute: minute);
    });

    SettingsLogic settingsLogic = new SettingsLogic();
    settingsLogic.firstLaunch.add(new FirstTimeInitialization());
  }

  final List<Widget> _children = [
    CalendarWindowWidgetWrapper(),
    MainWindowWidget(),
    FriendListWrapper(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StreamBuilder(
          stream: _bloc.index,
          initialData: 1,
          builder: (context, snapshot) {
            return Scaffold(
              body: _children[snapshot.data],
              bottomNavigationBar: BottomNavigationBar(
                onTap: onTabTapped,
                currentIndex: snapshot.data,
                items: [
                  ///Календарь со статистикой
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.calendar_today), label: 'Calendar'),

                  ///Главный экран с вводом информации
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.home), label: 'Home'),

                  /// социальная часть
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.account_box), label: 'Share')
                ],
              ),
            );
          },
        ),
        onWillPop: () async {
          return false;
        });
  }

  void onTabTapped(int index) {
    _bloc.pageScrollEventSink.add(PageScrollEvent(index));
  }
}
