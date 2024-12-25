
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../service/activity_service.dart';

abstract class Activity{
  int alertFrequency = 30;
  final FlutterTts flutterTts = FlutterTts();
  ActivityService activityService = ActivityService();

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Activity(){
    _initTts();
  }

  Future<void> save();

  Future<void> start();

  Widget getActivityWidget();

  void pause();
  void resume();
}