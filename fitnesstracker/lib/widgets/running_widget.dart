import 'package:fitnesstracker/activity/running_activity.dart';
import 'package:flutter/cupertino.dart';
String formatSpeed(double speed){
  if(speed>0.5){
    var totalSeconds = 1000 / speed;
    int minutes = (totalSeconds / 60).floor();
    int seconds = (totalSeconds % 60).floor();
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }
  else{
    return "--:--";
  }
}

class RunningWidget extends StatelessWidget{

  final RunningActivity activity;

  RunningWidget({super.key, required this.activity});

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
            '${(activity.getDistance()/1000).toStringAsFixed(3)} km',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Current Speed:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            formatSpeed(activity.getCurrentSpeed()),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
