// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningExercise _$RunningExerciseFromJson(Map<String, dynamic> json) =>
    RunningExercise(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num).toInt(),
      positions: (json['positions'] as List<dynamic>)
          .map((e) => PositionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      averagePace: json['averagePace'] as String,
    );

Map<String, dynamic> _$RunningExerciseToJson(RunningExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration,
      'positions': instance.positions.map((e) => e.toJson()).toList(),
      'totalDistance': instance.totalDistance,
      'averageSpeed': instance.averageSpeed,
      'averagePace': instance.averagePace,
    };

WeightliftingExercise _$WeightliftingExerciseFromJson(
        Map<String, dynamic> json) =>
    WeightliftingExercise(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num).toInt(),
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => WeightliftingSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeightliftingExerciseToJson(
        WeightliftingExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration,
      'exerciseName': instance.exerciseName,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
    };

WeightliftingSet _$WeightliftingSetFromJson(Map<String, dynamic> json) =>
    WeightliftingSet(
      weight: (json['weight'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
      exertionLevel: (json['exertionLevel'] as num).toInt(),
    );

Map<String, dynamic> _$WeightliftingSetToJson(WeightliftingSet instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'reps': instance.reps,
      'exertionLevel': instance.exertionLevel,
    };
