
import 'package:json_annotation/json_annotation.dart';
import 'exercise.dart';
import 'position_data.dart';

part 'activity_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityData {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final List<Exercise> exercises;
  final int totalTime; // in seconds
  final String name;
  final String? description;
  
  ActivityData({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.exercises,
    required this.totalTime,
    required this.name,
    this.description,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDataToJson(this);
  
  // Helper methods for backward compatibility and convenience
  double get totalDistance {
    return exercises
        .whereType<RunningExercise>()
        .fold(0.0, (sum, exercise) => sum + exercise.totalDistance);
  }
  
  List<RunningExercise> get runningExercises {
    return exercises.whereType<RunningExercise>().toList();
  }
  
  List<WeightliftingExercise> get weightliftingExercises {
    return exercises.whereType<WeightliftingExercise>().toList();
  }
  
  // Backward compatibility for positions - returns all positions from running exercises
  List<PositionData> get positions {
    List<PositionData> allPositions = [];
    for (var exercise in runningExercises) {
      allPositions.addAll(exercise.positions);
    }
    return allPositions;
  }
}