// running_interval.dart
import 'package:json_annotation/json_annotation.dart';

part 'running_interval.g.dart';

@JsonSerializable()
class RunningIntervalData {
  final int? id; // null for new intervals before insertion
  //final String planName;
  final String name;
  final int duration;
  final bool isDurationInSeconds;
  final int pace;

  RunningIntervalData({
    this.id,
    //required this.planName,
    required this.name,
    required this.duration,
    required this.isDurationInSeconds,
    required this.pace,
  });

  factory RunningIntervalData.fromJson(Map<String, dynamic> json) =>
      _$RunningIntervalDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunningIntervalDataToJson(this);
}
