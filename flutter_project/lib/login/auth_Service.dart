import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Future<UserCredential> signIn(String email, String passwd) {
    return auth.signInWithEmailAndPassword(email: email, password: passwd);
  }

  Future<UserCredential> signUp(String email, String passwd) {
    return auth.createUserWithEmailAndPassword(email: email, password: passwd);
  }

  Future<void> signOut(){
    return auth.signOut();
  }
}