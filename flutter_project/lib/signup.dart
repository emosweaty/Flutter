import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/login.dart';
import 'package:flutter_project/login/form.dart';
import 'home.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>{
  final email = TextEditingController();
  final passwd = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> signUp() async{
    setState(() {
      isLoading = true;
      error = null;
    });

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(), 
        password: passwd.text.trim()
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }on FirebaseAuthException catch (e){
      setState(() {
        error = e.message;
      });
    } catch (e){
      setState(() {
        error = 'An unexpected error occured';
      });
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthForm(
              email: email,
              passwd: passwd,
              isLoading: isLoading,
              error: error,
              onSubmit: signUp,
              btnLabel: 'Sign Up',
              label: 'Already have an account?',
              hreflabel: 'Sign In',
              routeName: LoginScreen.routeName,
            ),
          ],
        )
      ),
    );
  }


  @override
  void dispose() {
    email.dispose();
    passwd.dispose();
    super.dispose();
  }
}
