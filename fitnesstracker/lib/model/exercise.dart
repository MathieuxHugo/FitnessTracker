import 'package:json_annotation/json_annotation.dart';
import 'position_data.dart';

part 'exercise.g.dart';

abstract class Exercise {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String type;
  final int duration; // in seconds

  Exercise({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.type,
    required this.duration,
  });

  Map<String, dynamic> toJson();
  
  factory Exercise.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'running':
        return RunningExercise.fromJson(json);
      case 'weightlifting':
        return WeightliftingExercise.fromJson(json);
      default:
        throw ArgumentError('Unknown exercise type: ${json['type']}');
    }
  }
}

@JsonSerializable(explicitToJson: true)
class RunningExercise extends Exercise {
  final List<PositionData> positions;
  final double totalDistance;
  final double averageSpeed;
  final String averagePace;

  RunningExercise({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    required int duration,
    required this.positions,
    required this.totalDistance,
    required this.averageSpeed,
    required this.averagePace,
  }) : super(
          id: id,
          startTime: startTime,
          endTime: endTime,
          type: 'running',
          duration: duration,
        );

  factory RunningExercise.fromJson(Map<String, dynamic> json) =>
      _$RunningExerciseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RunningExerciseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WeightliftingExercise extends Exercise {
  final String exerciseName;
  final List<WeightliftingSet> sets;

  WeightliftingExercise({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    required int duration,
    required this.exerciseName,
    required this.sets,
  }) : super(
          id: id,
          startTime: startTime,
          endTime: endTime,
          type: 'weightlifting',
          duration: duration,
        );

  factory WeightliftingExercise.fromJson(Map<String, dynamic> json) =>
      _$WeightliftingExerciseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeightliftingExerciseToJson(this);
}

@JsonSerializable()
class WeightliftingSet {
  final double weight;
  final int reps;
  final int exertionLevel; // 1-10 scale

  WeightliftingSet({
    required this.weight,
    required this.reps,
    required this.exertionLevel,
  });

  factory WeightliftingSet.fromJson(Map<String, dynamic> json) =>
      _$WeightliftingSetFromJson(json);

  Map<String, dynamic> toJson() => _$WeightliftingSetToJson(this);
}