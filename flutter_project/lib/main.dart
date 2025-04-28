import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/login/auth_Service.dart';
import 'package:flutter_project/login/auth_model.dart';
import 'package:flutter_project/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/add.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authServ = AuthService(FirebaseAuth.instance);
  final authModel = AuthModel(authServ)..init();

  runApp(
    ChangeNotifierProvider.value(
      value: authModel,
      child: const MyApp()
      )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        AddScreen.routeName: (context) => const AddScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen()
      },
    );
  }
}
