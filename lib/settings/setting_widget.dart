import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/settings/settings_logic.dart';

class SettingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsWidgetState();
  }
}

class SettingsWidgetState extends State<SettingWidget> {
  SettingsLogic _bloc = new SettingsLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9FF),
      appBar: AppBar(
        title: Text("Notifications settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Notification enabled",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                StreamBuilder(
                  stream: _bloc.enabled,
                  initialData: true,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Switch(
                      value: snapshot.data,
                      onChanged: (value) => {
                        _bloc.enabledEventSink.add(new ChangeStateEnabled())
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next notification will be at ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                    width: 100,
                    height: 40,
                    child: StreamBuilder(
                        stream: _bloc.timeOfDay,
                        initialData: TimeOfDay.now(),
                        builder: (BuildContext context,
                            AsyncSnapshot<TimeOfDay> snapshot) {
                          var time = snapshot.data;
                          return MaterialButton(
                            onPressed: () {
                              _bloc.updateTime.add(new TryUpdateTime(context: context));
                            },
                            child: Text(time.hour.toString() + ":"+time.minute.toString()),
                            color: Colors.transparent,
                          );
                        }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
