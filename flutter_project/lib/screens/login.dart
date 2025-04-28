import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/login/form.dart';
import 'package:flutter_project/screens/signup.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  final email = TextEditingController();
  final passwd = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> signIn() async{
    setState(() {
      isLoading = true;
      error = null;
    });

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
              onSubmit: signIn,
              btnLabel: 'Sign In',
              label: "Don't have an account?",
              hreflabel: 'Sign Up',
              routeName: SignUpScreen.routeName,
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
