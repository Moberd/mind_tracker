
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mind_tracker/authorization/FirebaseUserRepository.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'authorization/authorization_window_widget.dart';
import 'package:mind_tracker/home/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notifications = new FlutterLocalNotificationsPlugin(); // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
var initializationSettingsAndroid =
new AndroidInitializationSettings('logo');
var initializationSettingsIOS = IOSInitializationSettings();
var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.deepPurple // status bar color
          ));


  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  print(timeZoneName);
  tz.setLocalLocation(tz.getLocation("Europe/Moscow"));
  notifications.initialize(initializationSettings);

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context){
        return AuthBloc(repository: FirebaseUserRepository())..add(AuthEventCheckAuth());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocListener<AuthBloc,AuthState>(
          listener: (context,state){
            print(state);
            if(state is AuthAuthenticated){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            }
            if(state is AuthUnauthenticated){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()));
            }
          },
          child:Center(child: CircularProgressIndicator()) ,
        ) ,
        ///Home(),
      ),
    );

  }
}
