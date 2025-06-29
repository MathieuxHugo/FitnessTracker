import 'package:json_annotation/json_annotation.dart';

part 'position_data.g.dart';

@JsonSerializable()
class PositionData {
  final double latitude;
  final double longitude;
  final int time;
  final double distance;
  final double accuracy;
  final double speedAccuracy;
  final double currentSpeed;

  PositionData({
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.distance,
    required this.accuracy,
    required this.speedAccuracy,
    required this.currentSpeed,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) =>
      _$PositionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PositionDataToJson(this);
}