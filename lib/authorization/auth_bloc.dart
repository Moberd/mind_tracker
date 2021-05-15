import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mind_tracker/authorization/FirebaseUserRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseUserRepository userRepository;
  String email;

  AuthBloc({@required FirebaseUserRepository repository}) :
        userRepository = repository,
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if(event is AuthEventCheckAuth){
      final isSignedIn = await userRepository.isAuthenticated();
      if(isSignedIn){
        email = await userRepository.getUserEmail();
        yield AuthAuthenticated();
      }
      else {
        yield AuthUnauthenticated();
      }
    }
    if(event is AuthEventLogin){
      await userRepository.authenticate(event.email, event.password);
      final isSignedIn = await userRepository.isAuthenticated();
      print(isSignedIn);
      if(isSignedIn){
        email = await userRepository.getUserEmail();
        yield AuthAuthenticated();
      }
      else {
        yield AuthUnauthenticated();
      }
    }
    if(event is AuthEventRegister){
      await userRepository.register(event.email, event.password);
      final isSignedIn = await userRepository.isAuthenticated();
      if(isSignedIn){
        email = await userRepository.getUserEmail();
        String name = event.name;
        if(name.isEmpty){
          name = "Brandon Floppa";
        }
       await FirebaseFirestore.instance.collection("users_friends").
        doc(email).
        set({"friends":[],"lastvisited":"","lastmark":"", "name":name,"pending":[]})
           .then((value) => print("User Added"))
           .catchError((error) => print("Failed to add user: $error"));

        yield AuthAuthenticated();
      }
      else {
        yield AuthUnauthenticated();
      }
    }
  }
}
