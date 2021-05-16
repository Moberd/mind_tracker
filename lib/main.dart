
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
import 'package:flutter/foundation.dart' show kIsWeb;


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

  if(!kIsWeb) {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    print(timeZoneName);
    tz.setLocalLocation(tz.getLocation("Europe/Moscow"));
    notifications.initialize(initializationSettings);
  }
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
            if(state is AuthAuthenticated){
              print(state);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            }
            if(state is AuthUnauthenticated){
              print(state);
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
int lang = 0;
class Strings {
  static const List<String> howAreYouToday = ["How are you today?", "Как дела?"];
  static const List<String> yourThoughtsToday = ["Your thoughts today", "Ваши мысли сегодня"];
  static const List<String> calendar = ["Calendar", "Календарь"];
  static const List<String> home = ["Home", "Домашний экран"];
  static const List<String> friends = ["Friends", "Друзья"];
  static const List<String> useQRToAddNewFriends = ["Use QR to add new friends", "Используйте сканер QR чтобы добавить друзей"];
  static const List<String> settings = ["Settings", "Настройки"];
  static const List<String> notificationEnabled = ["Notification enabled", "Уведомления включены"];
  static const List<String> nextNotificationWillBeAt = ["Next notification will be at", "Следующее уведомление:"];
  static const List<String> addFriends = ["Add friends", "Добавить друзей"];
  static const List<String> scanQR = ["Scan QR", "Сканировать QR"];
  static const List<String> shareQR = ["Share QR", "Мой QR"];
  static const List<String> myQR = ["My QR-code", "Мой QR-код"];
  static const List<String> pendingFriends = ["Pending friends", "Заявки в друзья"];
  static const List<String> addedFriends = ["Added friends", "Добавленные друзья"];
  static const List<String> enterFriendsEmail = ["Enter friend’s e-mail", "Введите e-mail друга"];
  static const List<String> thoughtDeleted = ["Thought deleted", "Мысль удалена"];
  static const List<String> exitAccount = ["Exit acount", "Выйти из аккаунта"];
  static const List<String> password = ["Password","Пароль"];
  static const List<String> forgotPassword = ["Forgot password","Забыл пароль"];
  static const List<String> login = ["Login","Войти"];
  static const List<String> register = ["Register","Регистрация"];
  static const List<String> yourName = ["Your name","Ваше имя"];
  static const List<String> lastVisit = ["Last visit on ","Последняя запись: "];
  static const List<String> rus_lang = ["RU","Рус"];
  static const List<String> eng_lang = ["EN","Англ"];
  static const List<String> empty_email = ["Email is empty", "Полe email пусто"];
  static const List<String> empty_password = ["Password is empty", "Полe пароля пусто"];
  static const List<String> weak_password = ["Password is too weak(at least 6 characters)", "Слишком слабый пароль(минимум 6 символов)"];
  static const List<String> sent_email = ["Email is sent", "На почту было отправлено письмо"];
  static const List<String> notification = ["Don`t forget to fill the day!", "Не забудь зайти в приложение!"];

}



