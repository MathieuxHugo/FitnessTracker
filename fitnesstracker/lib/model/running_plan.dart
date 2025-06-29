import 'package:json_annotation/json_annotation.dart';
import 'running_interval.dart';

part 'running_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class RunningPlanData {
  final String name;
  final List<RunningIntervalData> intervals;

  RunningPlanData({
    required this.name,
    required this.intervals,
  });

  factory RunningPlanData.fromJson(Map<String, dynamic> json) =>
      _$RunningPlanDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunningPlanDataToJson(this);
}
