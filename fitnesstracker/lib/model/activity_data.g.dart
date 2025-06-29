// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      positions: (json['positions'] as List<dynamic>)
          .map((e) => PositionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalTime: (json['totalTime'] as num).toInt(),
    );

Map<String, dynamic> _$ActivityDataToJson(ActivityData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'positions': instance.positions.map((e) => e.toJson()).toList(),
      'totalDistance': instance.totalDistance,
      'totalTime': instance.totalTime,
    };
