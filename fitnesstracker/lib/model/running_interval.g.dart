// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_interval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningIntervalData _$RunningIntervalDataFromJson(Map<String, dynamic> json) =>
    RunningIntervalData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      duration: (json['duration'] as num).toInt(),
      isDurationInSeconds: json['isDurationInSeconds'] as bool,
      pace: (json['pace'] as num).toInt(),
    );

Map<String, dynamic> _$RunningIntervalDataToJson(
        RunningIntervalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration': instance.duration,
      'isDurationInSeconds': instance.isDurationInSeconds,
      'pace': instance.pace,
    };
