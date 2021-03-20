import 'package:flutter/material.dart';
import 'package:mind_tracker/statistics/day_information_widget.dart';

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
  TextEditingController passwordController2 = TextEditingController();

  RegistrationWindowWidgetState(bool passVis) {
    _passwordVisible = passVis;
  }

/*Кто будет доставать отсюда пароли и тд, инструкция
https://coderoad.ru/61538657/%D0%9A%D0%B0%D0%BA-%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B8%D1%82%D1%8C-%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81-TextFormField-%D0%BF%D0%BE-Flutter
 */

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9FF),
      appBar: AppBar(title: Text("Registration")),
      body: Padding(
        padding:
            EdgeInsets.only(left: 60.0, top: 20.0, right: 60.0, bottom: 20.0),
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
                  decoration: new InputDecoration(labelText: "Login"),
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

                //Поле пароля 2
                TextFormField(
                  controller: passwordController2,
                  obscureText: _passwordVisible,
                  decoration: new InputDecoration(
                    labelText: "Repeat password",
                    /*//кнопка показа пароля
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
                        }),*/
                  ),
                ),


              ],
            ),

            //Кнопка авторизации
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    onPressed: register,
                    color: Color.fromARGB(123, 213, 128, 125),
                    minWidth: 200.0,
                    child: Text("Register"),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //TODO реализуйте регистрацию
  ///Регистрация
  void register()
  {
        Navigator.pop(context);
  }

}
