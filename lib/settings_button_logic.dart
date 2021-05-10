import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/settings/setting_widget.dart';

class StartSettingsPageEvent{
  BuildContext context;

  StartSettingsPageEvent({this.context});
}

class SettingButtonBloc {
  final _startDayStatisticPageController =
  StreamController<StartSettingsPageEvent>();

  Sink<StartSettingsPageEvent> get statisticPageEventSink =>
      _startDayStatisticPageController.sink;

  SettingButtonBloc(){
    _startDayStatisticPageController.stream.listen(_startDayStatisticPage);
  }

  void _startDayStatisticPage(StartSettingsPageEvent event) {
    Navigator.push(event.context, MaterialPageRoute(builder: (context) {
      return SettingWidget();
    }));
  }

  void dispose() {
    _startDayStatisticPageController.close();
  }
}
