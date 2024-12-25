  import 'dart:async';
  import 'dart:developer';

  import 'package:fitnesstracker/activity/activity.dart';
  import 'package:fitnesstracker/widgets/running_widget.dart';

  import 'package:flutter/material.dart';
  import 'package:geolocator/geolocator.dart';

  class RunningActivity extends Activity{

    List<Position> positions = [];
    double _distance = 0;
    StreamSubscription? _positionSubscription;


    double getCurrentSpeed() {
      if(positions.isNotEmpty){
        return positions.last.speed;
      }
      else{
        return 0;
      }
    }

    double getDistance(){
      return _distance;
    }


    Future<bool> _checkPermission() async {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
      // Request location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    }


    StreamSubscription _getPositionStream() {
      return Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
          intervalDuration: const Duration(seconds: 5),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "App continues to receive location updates.",
            notificationTitle: "Tracking in Background",
            enableWakeLock: true,
          ),
        ),
      ).listen((Position position) {
        if (positions.isNotEmpty) {
          _distance += Geolocator.distanceBetween(
              positions.last.latitude, positions.last.longitude,
              position.latitude, position.longitude);
        }
        positions.add(position);
      });
    }

    @override
    Future<void> save() async{
      _positionSubscription?.cancel();
      await activityService.saveActivity(positions);
    }

    @override
    Future<void> start() async{
      log("aaaaactityereh");
      await _checkPermission();
      _positionSubscription = _getPositionStream();
    }
    @override
    void pause() {
      _positionSubscription?.pause();
    }

    @override
    void resume() {
      _positionSubscription?.resume();
    }

    @override
    Widget getActivityWidget() {
      return RunningWidget(activity: this);
    }
  }

