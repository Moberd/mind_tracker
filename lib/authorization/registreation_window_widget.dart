import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_tracker/statistics/day_information_widget.dart';

import '../home.dart';

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
    return Scaffold(
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
              //TODO добавьте сюда лого приложения
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
                      onPressed: register,
                      color: Color.fromARGB(255, 159, 159, 237),
                      minWidth: 200.0,
                      child: Text("Register"),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  bool checkPassword(){
    return true;
  }
  Future<void>  register()
  async {
    if(checkPassword()){
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: loginController.text,
          password: passwordController1.text
      );
      CollectionReference usersFriends = FirebaseFirestore.instance.collection("users_friends");
      addUserFriends(usersFriends);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }}
  }
  Future<void> addUserFriends(CollectionReference users) {
    // Call the user's CollectionReference to add a new user
    if(nameController.text.isEmpty){
      nameController.text = "Brandon Floppa";
    }
    return users.doc(loginController.text).set({"friends":[],"lastvisited":"","lastmark":"","name":nameController.text})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


}
