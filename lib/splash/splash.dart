import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/authorization/authorization_window_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_tracker/home/home.dart';

class SplashWidget extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SplashWidgetState();
  }

}
class SplashWidgetState extends State<SplashWidget>{

  FirebaseAuth auth = FirebaseAuth.instance;
  void getFirebaseUser() async {
    await auth.authStateChanges().first;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
          builder: (context,sharedPref){
          if(sharedPref == null){
            print("sp null");
            return Center(child: CircularProgressIndicator());
          }
          if(sharedPref.data ==null){
            print("sp data null");
            return Center(child: CircularProgressIndicator());
          }
          if(sharedPref.data.containsKey("webauth")&&sharedPref.data.getBool("webauth")){
            print("token ready");
            print(sharedPref.data.getBool("webauth"));
            return FutureBuilder<UserCredential>(
              future: FirebaseAuth.instance.signInWithEmailAndPassword(email: sharedPref.data.getString("email"), password: sharedPref.data.getString("password")),
              builder: (context,user){
                if(user.data!=null){
                  Future.delayed(Duration.zero, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                  });

                  return Center(child: CircularProgressIndicator());

                }
                return Center(child: CircularProgressIndicator());

              },
            );
          }
          if(!sharedPref.data.containsKey("webauth")||!sharedPref.data.getBool("webauth")){
            print("token not  ready");
            Future.delayed(Duration.zero, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()));
            });

          }

          return Center(child: CircularProgressIndicator());
          }
      );
    }

    auth.authStateChanges()
        .listen((User user) {
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorizationWindowWidget()));
      }
    });
    //TODO()cюда бы сплешик какой
    return Center(child: CircularProgressIndicator(),);
  }

}