
import 'PositionData.dart';

class Activity {
  final String id;
  final DateTime startTime;
  final List<PositionData> positions;
  final double totalDistance;
  final int totalTime; // in seconds
  Activity({
    required this.id,
    required this.startTime,
    required this.positions,
    required this.totalDistance,
    required this.totalTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'positions': positions.map((pos) => pos.toJson()).toList(),
    'totalDistance': totalDistance,
  };
}