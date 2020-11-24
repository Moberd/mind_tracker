
import 'package:flutter/material.dart';

class PlaceHolderWidget extends StatelessWidget{
  final Color color;

  PlaceHolderWidget(this.color);  ///Конструктор

  @override
  Widget build(BuildContext context) {
    return Container( color: color);
  }
  
}