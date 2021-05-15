import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/authorization/authorization_window_widget.dart';
import 'package:mind_tracker/settings/settings_logic.dart';
import 'package:mind_tracker/main.dart';

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
        title: Text(Strings.settings[lang]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop()), 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.notificationEnabled[lang],
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
                  Strings.nextNotificationWillBeAt[lang],
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.eng_lang[lang],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Switch(
                      value: lang == 1,
                      onChanged: (value) => {
                        setState( () {lang = value ? 1 : 0;})
                      }
                ),
                Text(
                  Strings.rus_lang[lang],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()),(Route<dynamic> route) => false,);
              },
              child: Text(Strings.exitAccount[lang]),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
