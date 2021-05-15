import 'package:flutter/material.dart';
import 'package:mind_tracker/rate_day/main_window_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_tracker/settings/settings_logic.dart';
import '../rate_day/main_window_widget.dart';
import '../share/share_window_widget.dart';
import '../statistics/calendar_window_widget.dart';
import 'logic.dart';
import 'package:mind_tracker/main.dart';
SharedPreferences prefs;
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;


  @override
  void initState() {
    super.initState();
    getData();
  }



  getData() async {
    //Получение листа из памяти
    prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch =prefs.getInt("hours") == null ||prefs.getInt("minute") == null;
    int hour = prefs.getInt("hours") == null? TimeOfDay.now().hour:prefs.getInt("hours");
    int minute = prefs.getInt("minute") == null? TimeOfDay.now().minute:prefs.getInt("minute");
    notificationTime =TimeOfDay(hour: hour, minute: minute);
    if(isFirstLaunch) {
      SettingsLogic settingsLogic = new SettingsLogic();
      settingsLogic.firstLaunch.add(new FirstTimeInitialization());
    }
  }

  final List<Widget> _children = [
    CalendarWindowWidgetWrapper(),
    MainWindowWidget(),
    FriendsList(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:
        Scaffold(
         body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              ///Календарь со статистикой
              BottomNavigationBarItem(
                  icon: new Icon(Icons.calendar_today), label: Strings.calendar[lang]),

              ///Главный экран с вводом информации
              BottomNavigationBarItem(
                  icon: new Icon(Icons.home), label: Strings.home[lang]),

              /// социальная часть
              BottomNavigationBarItem(
                  icon: new Icon(Icons.account_box), label: Strings.friends[lang])
            ],
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
