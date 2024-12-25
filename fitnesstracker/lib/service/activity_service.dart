import 'package:geolocator/geolocator.dart';

import '../model/activity_data.dart';
import '../model/position_data.dart';
import '../repository/activity_repository.dart';

class ActivityService {
  final double accuracyThreshold;
  List<PositionData> positionsData = [];
  ActivityService({this.accuracyThreshold = 50.0});
  ActivityRepository activityRepository = ActivityRepository();

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


  Future<void> saveActivity(List<Position> positions) async {
    positionsData = [];
    double distance = 0;
    Position prev = positions.first;
    DateTime start = prev.timestamp;
    positionsData.add(positionToPositionData(prev, 0.0, 0));
    for(int i = 1; i< positions.length; i++){
      distance+=Geolocator.distanceBetween(prev.latitude, prev.longitude, positions[i].latitude, positions[i].longitude);
      prev=positions[i];
      positionsData.add(positionToPositionData(prev, distance, prev.timestamp.difference(start).inSeconds));
    }

    if(positionsData.isEmpty){
      throw "Bad Accuracy";
    }
    else{
      ActivityData activity = ActivityData(
        id: DateTime.now().toIso8601String(),
        startTime: positions.first.timestamp,
        totalTime: positions.first.timestamp.difference(positions.last.timestamp).inSeconds,
        totalDistance: distance,
        positions: positionsData,
      );
      await _saveActivityToDatabase(activity);
    }
  }

  Future<List<ActivityData>> getAllActivities(){
    return activityRepository.retrieveActivities();
  }

  Future<void> _saveActivityToDatabase(ActivityData activityData) async {
    activityRepository.saveActivity(activityData);
  }
}
