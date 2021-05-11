
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository{

  final FirebaseAuth firebaseAuth;
  FirebaseUserRepository({FirebaseAuth fb}): firebaseAuth = fb?? FirebaseAuth.instance;

  Future<bool> isAuthenticated() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }
  Future<void> authenticate(String email, String password) {
    return firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<void> register(String email, String password) {
    return firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<String> getUserEmail() async {
    return (firebaseAuth.currentUser).email;
  }
}