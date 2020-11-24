import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/placeholder_widget.dart';

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
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceHolderWidget(Colors.white),
    PlaceHolderWidget(Colors.grey),
    PlaceHolderWidget(Colors.orange)
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('page 1')),
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text('home')),

          ///Главное окно с вводом информации
          BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today),
              title: new Text('calendar')),

          /// статистика по дням
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_box), title: new Text('statistic'))

          ///
        ],
      ),
    );
  }

  void onTabTapped (int index){
    setState(() {
      _currentIndex=index;
    });
  }

}

