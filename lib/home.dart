import 'package:flutter/material.dart';
import 'package:mind_tracker/rate_day/main_window_widget.dart';

import 'share/share_window_widget.dart';
import 'statistics/calendar_window_widget.dart';
import 'rate_day/main_window_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

/// Сейчас новое окно/страница реализованы через PlaceHolderWidget
/// их нужно будет переделать под наши цели
/// не думаю, что это очень сложо
///
/// В лист можно засунуть разные наследники виджетов.
/// Думаю, будет проще написать по классу на каждую страницу, чем пытаться сделать один общий шаблон под разные параметы.
///
class _HomeState extends State<Home> {
  @override
  void initState(){
    getData();
  }

  getData() async { //Получение листа из памяти
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      thoughts_list = prefs.getStringList('thoughts_list') == null? [] : prefs.getStringList('thoughts_list');
    });
  }
  int _currentIndex = 1;
  final List<Widget> _children = [
    CalendarWindowWidget(),
    MainWindowWidget(),
    ShareWindowWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          //appBar: AppBar(title: Text('page 1')), ///Закомментируйте эту строку, когда создадите нормальные окна приложения
          body: _children[_currentIndex],

          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
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
