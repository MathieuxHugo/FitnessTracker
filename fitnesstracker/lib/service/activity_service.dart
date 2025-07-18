import 'package:geolocator/geolocator.dart';

import '../model/activity_data.dart';
import '../model/position_data.dart';
import '../model/exercise.dart';
import '../repository/json_repository.dart';
import '../utils/string_formatter.dart';

class ActivityService {
  final double accuracyThreshold;
  List<PositionData> positionsData = [];
  final JsonRepository _repository;

  ActivityService(this._repository, {this.accuracyThreshold = 50.0});

  static PositionData positionToPositionData(Position position, double distance, int time){
    return PositionData(latitude: position.latitude, longitude: position.longitude, time: time, distance: distance, accuracy: position.accuracy, currentSpeed: position.speed, speedAccuracy: position.speedAccuracy);
  }

  void addPointsBefore(int numberOfPoints, Position firstPosition, Position secondPosition){
    double longitudeIncrement = secondPosition.longitude-firstPosition.longitude;
    double latitudeIncrement = secondPosition.latitude-firstPosition.latitude;
    double startLongitude = firstPosition.longitude-longitudeIncrement*numberOfPoints;
    double startLatitude = firstPosition.latitude-latitudeIncrement*numberOfPoints;
    int timeIncrement = secondPosition.timestamp.difference(firstPosition.timestamp).inSeconds;
    double distanceIncrement = Geolocator.distanceBetween(firstPosition.latitude, firstPosition.longitude, secondPosition.latitude, secondPosition.longitude);
    //_addPoints(numberOfPoints, PositionData(latitude: startLatitude, longitude : startLongitude, distance: 0.0, time: 0), latitudeIncrement, longitudeIncrement, timeIncrement, distanceIncrement);
  }

  void addPositionsData(List<Position> positions) {
    int start =0;
    // Handle bad accuracy on first point
    while(start < positions.length && positions[start].accuracy>accuracyThreshold){
      start++;
    }
    Position first = positions[start];
    if(start!=0 && start < positions.length-1){
      }
    for (int i = start; i < positions.length; i++) {

      while(i < positions.length && positions[i].accuracy>accuracyThreshold){
        i++;
      }
    }
  }

  _addPoints(int numberOfPoints, PositionData startPoint, double latitudeIncrement, double longitudeIncrement, int timeIncrement, double distanceIncrement){
    for(int i = 0; i<numberOfPoints; i++){
      double latitude = startPoint.latitude+latitudeIncrement*i;
      double longitude = startPoint.longitude+longitudeIncrement*i;
      //double time = startPoint+timeIncrement*i;
      //double distance = startPoint.distance + distanceIncrement*i;
      //positionsData.add(PositionData(latitude: latitude, longitude: longitude, time : time, distance: distance));
    }
  }


  Future<void> saveActivity(ActivityData activity) async {
    await _repository.saveActivity(activity);
  }

  Future<void> saveRunningActivity(List<Position> positions) async {
    positionsData = [];
    double distance = 0;
    Position prev = positions.first;
    DateTime start = prev.timestamp;
    DateTime end = positions.last.timestamp;
    positionsData.add(positionToPositionData(prev, 0.0, 0));
    
    double totalSpeed = 0;
    int speedCount = 0;
    
    for(int i = 1; i< positions.length; i++){
      distance+=Geolocator.distanceBetween(prev.latitude, prev.longitude, positions[i].latitude, positions[i].longitude);
      prev=positions[i];
      positionsData.add(positionToPositionData(prev, distance, prev.timestamp.difference(start).inSeconds));
      
      if (prev.speed > 0) {
        totalSpeed += prev.speed;
        speedCount++;
      }
    }

    if(positionsData.isEmpty){
      throw "Bad Accuracy";
    }
    else{
      double averageSpeed = speedCount > 0 ? totalSpeed / speedCount : 0;
      String averagePace = averageSpeed > 0 ? StringFormatter.formatPaceFromSpeed(averageSpeed) : "--:--";
      
      RunningExercise runningExercise = RunningExercise(
        id: "${DateTime.now().toIso8601String()}_running",
        startTime: start,
        endTime: end,
        duration: end.difference(start).inSeconds,
        positions: positionsData,
        totalDistance: distance,
        averageSpeed: averageSpeed,
        averagePace: averagePace,
      );
      
      ActivityData activity = ActivityData(
        id: DateTime.now().toIso8601String(),
        startTime: start,
        endTime: end,
        exercises: [runningExercise],
        totalTime: end.difference(start).inSeconds,
        name: "Running Activity",
        description: "Automatically tracked running session",
      );
      await _repository.saveActivity(activity);
    }
  }

  Future<List<ActivityData>> getAllActivities(){
    return _repository.retrieveActivities();
  }
  
  Future<void> deleteActivity(String activityId) async {
    await _repository.deleteActivity(activityId);
  }
}
