// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningPlanData _$RunningPlanDataFromJson(Map<String, dynamic> json) =>
    RunningPlanData(
      name: json['name'] as String,
      intervals: (json['intervals'] as List<dynamic>)
          .map((e) => RunningIntervalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RunningPlanDataToJson(RunningPlanData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'intervals': instance.intervals.map((e) => e.toJson()).toList(),
    };
