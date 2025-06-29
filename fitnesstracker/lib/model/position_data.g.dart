// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionData _$PositionDataFromJson(Map<String, dynamic> json) => PositionData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      time: (json['time'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      speedAccuracy: (json['speedAccuracy'] as num).toDouble(),
      currentSpeed: (json['currentSpeed'] as num).toDouble(),
    );

Map<String, dynamic> _$PositionDataToJson(PositionData instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'time': instance.time,
      'distance': instance.distance,
      'accuracy': instance.accuracy,
      'speedAccuracy': instance.speedAccuracy,
      'currentSpeed': instance.currentSpeed,
    };
