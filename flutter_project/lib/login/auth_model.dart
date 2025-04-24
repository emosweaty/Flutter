import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_Service.dart';

class AuthModel with ChangeNotifier {
  final AuthService service;
  AuthModel(this.service);

  User? user;
  User? get currentUser => user;

  bool loading = false;
  bool get isLoading => loading;

  String? error;
  String? get getError => error;

  void init(){
    service.auth.authStateChanges().listen((user){
      user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String passwd) async{
    setLoading(true);
    try{
      await service.signIn(email, passwd);
    } on FirebaseException catch (e){
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUp(String email, String passwd) async{
    setLoading(true);
    try{
      await service.signUp(email, passwd);
    } on FirebaseAuthException catch (e){
      setError(e.message);
    } finally{
      setLoading(false);
    }
  }

  Future<void> signOut() async{
    setLoading(true);
    await service.signOut();
    setLoading(false);
  }

  void setLoading(bool state){
    loading = state;
    notifyListeners();
  }

  void setError(String? message){
    error = message;
    notifyListeners();
  }
}
