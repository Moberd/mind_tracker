import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mind_tracker/home/home.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class ChangeStateEnabled {}

class TryUpdateTime {
  BuildContext context;

  TryUpdateTime({this.context});
}

class FirstTimeInitialization {

  FirstTimeInitialization();
}

TimeOfDay notificationTime;

class SettingsLogic {
  TimeOfDay _timeOfDay;
  bool _isEnabled;
  final StreamController<TimeOfDay> _timeStateController =
      StreamController<TimeOfDay>();

  Stream<TimeOfDay> get timeOfDay => _timeStateController.stream;

  StreamSink<TimeOfDay> get _inTimeOfDay => _timeStateController.sink;
  final StreamController<TryUpdateTime> _timeChangeEventController =
      StreamController<TryUpdateTime>();

  Sink<TryUpdateTime> get updateTime => _timeChangeEventController.sink;

  final StreamController<bool> _enabledStateController =
      StreamController<bool>();

  StreamSink<bool> get _inEnabled => _enabledStateController.sink;

  Stream<bool> get enabled => _enabledStateController.stream;
  final _enabledEventController = StreamController<ChangeStateEnabled>();

  Sink<ChangeStateEnabled> get enabledEventSink => _enabledEventController.sink;

  final _firstLaunchEventController =
      StreamController<FirstTimeInitialization>();

  Sink<FirstTimeInitialization> get firstLaunch =>
      _firstLaunchEventController.sink;

  SettingsLogic() {
    print(notificationTime);
    _isEnabled = prefs.getBool("isNotificationEnabled") == null
        ? true
        : prefs.getBool("isNotificationEnabled");
    _inEnabled.add(_isEnabled);
    _enabledEventController.stream.listen(_changeState);
    _timeChangeEventController.stream.listen(_getNewTime);
    _timeOfDay = notificationTime;
    _inTimeOfDay.add(_timeOfDay);
    _firstLaunchEventController.stream.listen(_init);
  }

  void _changeState(ChangeStateEnabled event) {
    _isEnabled = !_isEnabled;

    if (_isEnabled) {
      _enableNotifications(_timeOfDay);
    } else {
      _disableNotifications();
    }
    prefs.setBool("isNotificationEnabled", _isEnabled);
    _inEnabled.add(_isEnabled);
  }

  void _getNewTime(TryUpdateTime event) async {
    if (_isEnabled) {
      final TimeOfDay newTime = await showTimePicker(
        context: event.context,
        initialTime: _timeOfDay,
      );
      if (newTime != null) {
        _timeOfDay = newTime;
        _inTimeOfDay.add(newTime);
        notificationTime = newTime;
        prefs.setInt("hours", newTime.hour);
        prefs.setInt("minute", newTime.minute);
        _enableNotifications(newTime);
      }
    }
  }

  void _enableNotifications(TimeOfDay time) async {
    _disableNotifications();
    var notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "announcement_app_0",
          "Notification",
          "",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails());
    var nextTime = _nextInstance(time);
    await notifications.zonedSchedule(0, Strings.howAreYouToday[lang],
        Strings.notification[lang], nextTime, notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  void _disableNotifications() async {
    await notifications.cancel(0);
  }

  tz.TZDateTime _nextInstance(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _init(FirstTimeInitialization event) {
    var time = notificationTime;
    _enableNotifications(time);
    prefs.setInt("hours", time.hour);
    prefs.setInt("minute", time.minute);
  }

  void dispose() {
    _enabledEventController.close();
    _enabledStateController.close();
    _timeStateController.close();
    _timeChangeEventController.close();
    _firstLaunchEventController.close();
  }
}
