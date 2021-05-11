import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mind_tracker/authorization/FirebaseUserRepository.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/splash/splash.dart';
import 'authorization/authorization_window_widget.dart';
import 'package:mind_tracker/home/home.dart';
import 'package:flutter/services.dart';


FlutterLocalNotificationsPlugin notifications = new FlutterLocalNotificationsPlugin(); // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
var initializationSettingsAndroid =
new AndroidInitializationSettings('ic_launcher');
var initializationSettingsIOS = IOSInitializationSettings();
var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.deepPurple // status bar color
          ));
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
    
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //return SomethingWentWrong(); экран ошибочки
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
                home:SplashWidget() ,
             ///Home(),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
       // return Loading(); экран загрузки
        return MaterialApp(
          home: Scaffold(
            body:Center(
              child:CircularProgressIndicator()
            ) ,
          ),
        );

      },
    );
  }
}
