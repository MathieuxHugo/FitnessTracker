import 'package:fitnesstracker/model/running_interval.dart';

class RunningPlan {
  final String name;
  final List<RunningInterval> intervals;

  RunningPlan({
    required this.name,
    required this.intervals,
  });

  RunningPlan.createPlan({
    required this.name,
    required this.intervals,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'intervals': intervals.map((interval) => interval.toJson()).toList(),
  };
}
