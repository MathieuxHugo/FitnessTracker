import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';

class PositionTracker {

  List<Position> positions = [];
  double _distance = 0;
  FlutterTts textToSpeak;
  int alertFrequency = 30;
  StreamSubscription? _positionSubscription = null;

  PositionTracker(this.textToSpeak, this.alertFrequency);

  void startTrackingSpeed() async {
    await _checkPermission();
    _positionSubscription = _getPositionStream();
  }

  void stopTrackingSpeed() {
    _positionSubscription?.pause();
  }

  double getCurrentSpeed() {
    return positions.last.speed;
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
      //TODO add tts
    });
  }
}

