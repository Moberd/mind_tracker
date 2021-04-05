import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/authorization/registreation_window_widget.dart';

import '../home.dart';

class AuthorizationWindowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AuthorizationWindowWidgetState(true);
  }
}

class AuthorizationWindowWidgetState extends State<AuthorizationWindowWidget> {
  bool _passwordVisible;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthorizationWindowWidgetState(bool passVis) {
    _passwordVisible = passVis;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.only(
                left: 60.0, top: 20.0, right: 60.0, bottom: 20.0),
            child: Stack(
              children: [
                //TODO добавьте сюда лого приложения

                //Центральный блок
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Поле логина
                    TextFormField(
                      controller: loginController,
                      decoration: new InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    //Поле пароля
                    TextFormField(
                      controller: passwordController,
                      obscureText: _passwordVisible,
                      decoration: new InputDecoration(
                        labelText: "Password",

                        //кнопка показа пароля
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                      ),
                    ),

                    //кнопка восстановления пароля
                    FlatButton(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot password",
                        ),
                      ),
                      onPressed: onForgotPassword,
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.transparent),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                    )
                  ],
                ),

                //Нижний блок
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //Кнопка авторизации
                            MaterialButton(
                              onPressed: login,
                              color: Color.fromARGB(123, 213, 128, 125),
                              minWidth: 200.0,
                              child: Text("Login"),
                            ),

                            //Кнопка регистрации
                            FlatButton(
                              child: Text("Register"),
                              onPressed: () => onRegister(context),
                              textColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            )
                          ],
                        )))
              ],
            ),
          ),
        ));
  }

  //TODO Напишите функцию
  ///Восстановление пароля
   void onForgotPassword() {
    auth.sendPasswordResetEmail(email: loginController.text);
    //TODO тостик по мылу отправлен ссылка на восстановление пароля
  }

  //TODO написать страницу регистрации
  ///Переход на страницу регистрации
  static void onRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationWindowWidget()),
    );
  }

  //TODO добавьте функцию авторизации
  ///Авторизация
  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:loginController.text,
          password: passwordController.text
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
