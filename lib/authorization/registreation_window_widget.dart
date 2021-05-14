import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_tracker/statistics/day_information_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_tracker/home/home.dart';

import 'auth_bloc.dart';

class RegistrationWindowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegistrationWindowWidgetState(true);
  }
}

class RegistrationWindowWidgetState extends State<RegistrationWindowWidget> {
  bool _passwordVisible;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController nameController = TextEditingController();

  RegistrationWindowWidgetState(bool passVis) {
    _passwordVisible = passVis;
  }

  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFE9DDF6),
          appBar: AppBar(title: Text("Registration")),
          body: Padding(
            padding:
            EdgeInsets.only(left: 60.0, top: 20.0, right: 60.0, bottom: 20.0),
            child: SingleChildScrollView(
              reverse: true,
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

                      //Поле пароля 1
                      TextFormField(
                        controller: passwordController1,
                        obscureText: _passwordVisible,
                        decoration: new InputDecoration(
                          labelText: "Password",
                          //кнопка показа пароля
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme
                                    .of(context)
                                    .primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                        ),
                      ),

                      //Поле пароля 2
                      TextFormField(
                        controller: nameController,
                        decoration: new InputDecoration(labelText: "Your Name"),
                      ),


                    ],
                  ),

                  //Кнопка авторизации
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MaterialButton(
                          onPressed: () => OnRegister(context),
                          color: Color.fromARGB(255, 159, 159, 237),
                          minWidth: 200.0,
                          child: Text("Register"),
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
  void OnRegister(BuildContext context)async {
    BlocProvider.of<AuthBloc>(context).add(AuthEventRegister(loginController.text, passwordController1.text,nameController.text));
  }
}
