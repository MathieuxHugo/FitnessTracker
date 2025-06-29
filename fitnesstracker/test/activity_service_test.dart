import 'package:fitnesstracker/model/activity_data.dart';
import 'package:fitnesstracker/model/position_data.dart';
import 'package:fitnesstracker/repository/json_repository.dart';
import 'package:fitnesstracker/service/activity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'activity_service_test.mocks.dart';

@GenerateMocks([JsonRepository])
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
    test('saveActivity saves the activity', () async {
      final mockRepo = MockJsonRepository();
      final service = ActivityService(mockRepo, accuracyThreshold: 50.0);
      final positions = [
        createPosition(40.7128, -74.0060, 10.0, DateTime.now()),
        createPosition(40.7129, -74.0070, 10.0, DateTime.now()),
      ];

      await service.saveActivity(positions);

      verify(mockRepo.saveActivity(any)).called(1);
    });
  });
}
