import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mind_tracker/home/home.dart';

import '../main.dart';

class ChangeStateEnabled {}

class TryUpdateTime {
  BuildContext context;

  TryUpdateTime({this.context});
}

class SettingsLogic {
  InitializationSettings _initializationSettings;

  TimeOfDay _timeOfDay = TimeOfDay.now();
  bool _isEnabled = true;
  final StreamController<TimeOfDay> _timeStateController =
  StreamController<TimeOfDay>();

  Stream<TimeOfDay> get timeOfDay => _timeStateController.stream;

  StreamSink<TimeOfDay> get _inTimeOfDay => _timeStateController.sink;
  final StreamController<TryUpdateTime> _timeChangeEventontroller =
  StreamController<TryUpdateTime>();

  Sink<TryUpdateTime> get updateTime => _timeChangeEventontroller.sink;


  final StreamController<bool> _enabledStateController =
  StreamController<bool>();

  StreamSink<bool> get _inEnabled => _enabledStateController.sink;

  Stream<bool> get enabled => _enabledStateController.stream;
  final _enabledEventController = StreamController<ChangeStateEnabled>();

  Sink<ChangeStateEnabled> get enabledEventSink => _enabledEventController.sink;

  SettingsLogic() {


    _inEnabled.add(_isEnabled);
    _enabledEventController.stream.listen(_changeState);
    _timeChangeEventontroller.stream.listen(_getNewTime);
    _inTimeOfDay.add(TimeOfDay.now());
  }

  void _changeState(ChangeStateEnabled event) {
    _isEnabled = !_isEnabled;


    _inEnabled.add(_isEnabled);
  }

  void _getNewTime(TryUpdateTime event) async
  {
    if (_isEnabled) {
      final TimeOfDay newTime = await showTimePicker(
        context: event.context,
        initialTime: _timeOfDay,
      );
      if (newTime != null) {
        _timeOfDay = newTime;
        _inTimeOfDay.add(newTime);
        enableNotifications(newTime);
      }
    }
  }

  void _voidFunc() {}

  void enableNotifications(TimeOfDay time) async {

    notifications.show(
        0,
        "Your mood",
        "Don't forget to fill the days!",
        NotificationDetails(
            android: AndroidNotificationDetails(
                "announcement_app_0",
                "Announcement App",
                ""
            ),
            iOS: IOSNotificationDetails()
        )
    );
  }

  void disableNotifications(TimeOfDay time) {

  }


  void dispose() {
    _enabledEventController.close();
    _enabledStateController.close();
    _timeStateController.close();
    _timeChangeEventontroller.close();
  }
}
