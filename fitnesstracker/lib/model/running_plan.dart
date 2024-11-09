import 'package:fitnesstracker/model/running_interval.dart';

class RunningPlan {
  String id;
  final String name;
  final List<RunningInterval> intervals;

  RunningPlan({
    required this.id,
    required this.name,
    required this.intervals,
  });

  RunningPlan.createPlan({this.id="0",
    required this.name,
    required this.intervals,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'intervals': intervals.map((interval) => interval.toJson()).toList(),
  };
}
