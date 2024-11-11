import 'dart:async';
import 'package:fitnesstracker/service/activity_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_tts/flutter_tts.dart';

class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});
  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}



class _NewActivityPageState extends State<NewActivityPage> {
  double _currentSpeed = 0;
  String _minKM = "--:--";
  String timerText = "00:00:00";
  Timer? _timer;
  double distance = 0;
  DateTime start = DateTime.now(), startPause = DateTime.now();
  Duration pauseDuration = Duration.zero;
  String _lastUpdate="none"; // update frequency
  bool _isTracking = false; // Track if tracking is started
  bool _isPaused = false;  // Track if tracking has been paused
  List<Position> positions = [];
  ActivityService activityService = ActivityService();
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState(){
    super.initState();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  void _startTimer() {
    start = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if(!_isPaused){
          timerText = _formatTime((DateTime.now().difference(start)-pauseDuration).inSeconds);
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  Future<void> _startTrackingSpeed() async {
    _initTts();
    bool serviceEnabled;
    LocationPermission permission;
    _lastUpdate="Starting Tracking...";
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _lastUpdate="Starting Tracking Failed";
      return;
    }
    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _lastUpdate="Permission denied";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _lastUpdate="Permission denied forever";
      return;
    }
    _lastUpdate="Tracking started successfully";

    // Start listening to location updates to calculate speed
    Geolocator.getPositionStream(
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
      setState(() {
        if(!positions.isEmpty){
          distance += Geolocator.distanceBetween(positions.last.latitude, positions.last.longitude, position.latitude, position.longitude);
        }
        positions.add(position);
        if (position.speed > 0.2) {
          _currentSpeed = position.speed * 3.6;
          var totalSeconds = 1000 / position.speed;
          int minutes = (totalSeconds / 60).floor();
          int seconds = (totalSeconds % 60).floor();
          _minKM = '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
        }
        else{
          _minKM = "--:--";
          _currentSpeed = 0;
        }
        _lastUpdate = position.accuracy.toStringAsFixed(1);

      });
    }).onError((error){
      _lastUpdate = "Error";
    });
  }

  void _onStart() {
    setState(() {
      _isTracking = true;
      _isPaused = false;
      timerText = "00:00:00";
    });
    _startTimer();
    _startTrackingSpeed();
  }

  void _onPause() {
    setState(() {
      _isPaused = true;
      startPause = DateTime.now();
    });
  }

  void _onResume() {
    setState(() {
      _isPaused = false;
      _isTracking = true;
      pauseDuration += DateTime.now().difference(startPause);
    });
    _startTrackingSpeed();
  }

  void _onSave() {
    activityService.saveActivity(positions).then((onValue){
      positions=[];
      setState(() {
        _isTracking = false;
        _isPaused = false;
        timerText = "00:00:00";
      });
      _stopTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Distance:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            "${(distance/1000).toStringAsFixed(2)} km",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text(
            'Timer:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            timerText,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Current Speed ($_lastUpdate):',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            "${_currentSpeed.toStringAsFixed(2)} km/h\n$_minKM min/km",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (!_isTracking) {
      // Start Button
      return ElevatedButton(
        onPressed: _onStart,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(24),
        ),
        child: Text(
          "Start",
          style: TextStyle(fontSize: 24),
        ),
      );
    } else if (_isTracking && !_isPaused) {
      // Pause Button
      return ElevatedButton(
        onPressed: _onPause,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(24),
          backgroundColor: Colors.red,
        ),
        child: Text(
          "Pause",
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      // Restart and Save Buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _onResume,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
            ),
            child: Text(
              "Resume",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              padding: EdgeInsets.all(24),
              backgroundColor: Colors.green,
            ),
            child: Text(
              "Save",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
    }
  }
}
