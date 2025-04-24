import 'package:flutter/material.dart';
import 'appbar.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  static const String routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Text('add'),
    );
  }
}
