
import 'package:json_annotation/json_annotation.dart';
import 'position_data.dart';

part 'activity_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityData {
  final String id;
  final DateTime startTime;
  final List<PositionData> positions;
  final double totalDistance;
  final int totalTime; // in seconds
  ActivityData({
    required this.id,
    required this.startTime,
    required this.positions,
    required this.totalDistance,
    required this.totalTime,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDataToJson(this);
}