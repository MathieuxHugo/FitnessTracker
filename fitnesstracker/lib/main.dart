import 'package:fitnesstracker/repository/json_repository.dart';
import 'package:fitnesstracker/service/json_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_screen.dart';

void main() {
  runApp(RunningApp());
}

class RunningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<JsonRepository>(
      create: (_) => JsonRepository(JsonStorageService()),
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
