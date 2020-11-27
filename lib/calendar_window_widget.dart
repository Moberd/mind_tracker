///правый экран с календарем и статистикой
import 'package:flutter/material.dart';

class CalendarWindowWidget extends StatelessWidget {
  /// Год окончания должен быть больше года начала, иначе ошибка,
  /// даже при одиом годе

  final int _yearOfBeginningOfApp = 2020;
  final int _yearOfEndingOfApp = 2021;

  CalendarWindowWidget();

  bool _isEven(DateTime a){
    if (a.day < DateTime.now().day)
      return true;
    else
      return false;
  }

  void startDayStatisticPage(BuildContext context) {

    Navigator.push(context, MaterialPageRoute(builder: (context) => DayStatisticPage())
      ,);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF9FF),
        body: new Padding(
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: [
              CalendarDatePicker(
                ///Не уверен, как тут выделить дни для обозначения о каком дне есть информация
                ///Возможно, календарь придется менять
                initialDate: DateTime.now(),
                firstDate: DateTime(_yearOfBeginningOfApp),
                lastDate: DateTime(_yearOfEndingOfApp),

                ///Нужно новое окно с выводом информации по дню.
                onDateChanged: (value) => {startDayStatisticPage(context)},
               /// selectableDayPredicate: _isEven,

                ///Тут должно быть вызвано окно с информацией по дню
                currentDate: DateTime.now(),
                initialCalendarMode: DatePickerMode.day,
              ),
              new Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: new Text('Что ты тут делаешь?'))

            ], //children
          ),
        ));
  }
}

class DayStatisticPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

///Функция используется как демонстрация и в будущем должна быть заменена на функцию, возвращающую, имеются ли записи за день

