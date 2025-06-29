
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:fitnesstracker/repository/json_repository.dart';

import '../service/activity_service.dart';

abstract class Activity {
  int alertFrequency = 30;
  final FlutterTts flutterTts = FlutterTts();
  late ActivityService activityService;

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Activity(JsonRepository repository) {
    activityService = ActivityService(repository);
    _initTts();
  }

  Future<void> save();

  Future<void> start();

  Widget getActivityWidget();

  void pause();
  void resume();
}