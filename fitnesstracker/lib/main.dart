import 'package:flutter/material.dart';
import 'pages/home_screen.dart';

void main() {
  runApp(RunningApp());
}

class RunningApp extends StatelessWidget {

  final HomeScreen homeScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeScreen,
    );
  }
}
