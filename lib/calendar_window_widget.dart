///правый экран с календарем и статистикой

import 'package:flutter/material.dart';

class CalendarWindowWidget extends StatelessWidget{

  /// Год окончания должен быть больше года начала, иначе ошибка,
  /// даже при одиом годе

  final int _yearOfBeginningOfApp = 2020;
  final int _yearOfEndingOfApp = 2021;

  CalendarWindowWidget ();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9FF),
      body: new Column(
        children: [
         CalendarDatePicker( ///Не уверен, как тут выделить дни для обозначения о каком дне есть информация
                             ///Возможно, календарь придется менять
             initialDate: DateTime.now(),
             firstDate: DateTime(_yearOfBeginningOfApp),
             lastDate: DateTime(_yearOfEndingOfApp),
             onDateChanged: (value) =>{} , ///Тут должно быть вызвано окно с информацией по дню
             currentDate: DateTime.now(),
           initialCalendarMode: DatePickerMode.day,
         ),
          new Text('Что ты тут делаешь?')   ///,
         /// new TextField()

        ], //children
      ),
    );
  }

}