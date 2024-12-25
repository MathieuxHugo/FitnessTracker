import 'package:fitnesstracker/model/position_data.dart';
import 'package:fitnesstracker/service/activity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';


Position createPosition(double latitude, double longitude, double accuracy, DateTime timestamp){
  return Position(longitude: longitude, latitude: latitude, timestamp: timestamp, accuracy: accuracy, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
}

void expectPositionData(PositionData test, PositionData expected){
  expect(test.longitude,expected.longitude);
  expect(test.latitude,expected.latitude);
  expect(test.time,expected.time);
  //expect(test.distance,expected.distance);
}

void main() {
  group('ActivityService', () {
    test('addPointsBefore', () {
      // Arrange: Create test positions with varying accuracy
      Position firstPosition = createPosition(40.7128,-74.0060,10.0, DateTime.fromMillisecondsSinceEpoch(6000));
      Position secondPosition = createPosition(40.7129, -74.0070,10.0, DateTime.fromMillisecondsSinceEpoch(8000));


      // Act: Instantiate service and filter by accuracy threshold of 50
      ActivityService activityService = ActivityService(accuracyThreshold: 50.0);
      activityService.addPointsBefore(2, firstPosition, secondPosition);

      // Assert: Only 1 position should be left after filtering
      expect(activityService.positionsData.length, 2);

      //expectPositionData(activityService.positionsData[0],PositionData(latitude: 40.7126, longitude: -74.0040, time: 0, distance: 0));
      //expectPositionData(activityService.positionsData[0],PositionData(latitude: 40.7127, longitude: -74.0050, time: 0, distance: 0));
    });

    test('corrects low accuracy points by interpolation', () {
      // Arrange: Create test positions, including one with low accuracy
      List<Position> testPositions = [
        createPosition(40.7128, -74.0060, 10.0, DateTime.now()),
        createPosition(40.7129, -74.0070, 100.0, DateTime.now()),
        createPosition( 40.7130, -74.0080, 10.0, DateTime.now()),
      ];

      // Act: Instantiate service and correct low accuracy points
      //ActivityService activityService = ActivityService(testPositions, accuracyThreshold: 50.0);
      //List<Position> correctedPositions = activityService._correctLowAccuracyPoints(testPositions);

      // Assert: Check that the low accuracy point was interpolated
      //expect(correctedPositions[1].accuracy, lessThanOrEqualTo(50.0));
      //expect(correctedPositions[1].latitude, closeTo(40.7129, 0.0001));
    });
  });
}
