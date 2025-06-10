import 'running_interval.dart';

class RunningPlanData {
  final String name;
  final List<RunningIntervalData> intervals;

  RunningPlanData({
    required this.name,
    required this.intervals,
  });

  factory RunningPlanData.fromJson(Map<String, dynamic> json) => RunningPlanData(
    name: json['name'],
    intervals: (json['intervals'] as List)
      .map((i) => RunningIntervalData.fromJson(i))
      .toList(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'intervals': intervals.map((i) => i.toJson()).toList(),
  };
}
