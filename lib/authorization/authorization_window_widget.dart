import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/authorization/registreation_window_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mind_tracker/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_tracker/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    print(BlocProvider.of<AuthBloc>(context).email);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print(state);
        if (state is AuthAuthenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      },
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Color(0xFFE9DDF6),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 60.0, top: 60.0, right: 60.0, bottom: 20.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 256,
                    ),
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
                            labelText: Strings.password[lang],

                            //кнопка показа пароля
                            suffixIcon: IconButton(
                                icon: Icon(
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
                              Strings.forgotPassword[lang],
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
                                  onPressed: () => onLogin(context),
                                  color: Color.fromARGB(255, 159, 159, 237),
                                  minWidth: 200.0,
                                  child: Text(Strings.login[lang]),
                                ),
                                //Кнопка регистрации
                                FlatButton(
                                  child: Text(Strings.register[lang]),
                                  onPressed: () => onRegister(context),
                                  textColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                )
                              ],
                            )))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void onForgotPassword() {
    if (loginController.text.length == 0) {
      Fluttertoast.showToast(
          msg: Strings.empty_email[lang], backgroundColor: Colors.red);
    } else {
      auth.sendPasswordResetEmail(email: loginController.text);
      Fluttertoast.showToast(msg: Strings.sent_email[lang], backgroundColor: Colors.green);
    }
  }

  static void onRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationWindowWidget()),
    );
  }

  void onLogin(BuildContext context) async {
    BlocProvider.of<AuthBloc>(context)
        .add(AuthEventLogin(loginController.text, passwordController.text));
  }
}
