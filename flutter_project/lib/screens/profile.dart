import 'package:flutter/material.dart';
import '../appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('profile'),
    );
  }
}
