import 'dart:async';
import 'dart:developer';
import 'package:fitnesstracker/activity/running_activity.dart';
import 'package:flutter/material.dart';

import '../activity/activity.dart';

class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});
  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  String timerText = "00:00:00";
  Timer? _timer;
  DateTime start = DateTime.now(), startPause = DateTime.now();
  Duration pauseDuration = Duration.zero;
  bool _isTracking = false; // Track if tracking is started
  bool _isPaused = false; // Track if tracking has been paused
  late Activity activity;

  @override
  void initState() {
    super.initState();
    activity = createActivity();
  }

  Activity createActivity() {
    return RunningActivity(minSpeed: 0.5, maxSpeed: 15);
  }

  void _startTimer() {
    start = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!_isPaused) {
          timerText = _formatTime(
              (DateTime.now().difference(start) - pauseDuration).inSeconds);
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

  void _onStart() {
    activity.start().then((onValue) {
      setState(() {
        _isTracking = true;
        _isPaused = false;
        timerText = "00:00:00";
      });
      _startTimer();
    });
  }

  void _onPause() {
    setState(() {
      activity?.pause();
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
  }

  void _onSave() {
    activity?.save().then((onValue) {
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
            'Timer:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            timerText,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          activity.getActivityWidget(),
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
