import 'package:fitnesstracker/model/running_interval.dart';

import '../model/running_plan.dart';

class RunningPlansService {
  Future<List<RunningPlanData>> getRunningPlans() async {
    // Mock data for now
    return [
      RunningPlanData(name: "5K Training Plan", intervals:[RunningIntervalData(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: true), RunningIntervalData(name: "dddd", duration:200, pace: 360, isDurationInSeconds: true)]),
      RunningPlanData(name: "Marathon Prep", intervals : [RunningIntervalData(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: false), RunningIntervalData(name: "dddd", duration: 360, pace: 360, isDurationInSeconds: true)]),
      RunningPlanData(name: "Interval Training", intervals:[RunningIntervalData(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: true), RunningIntervalData(name: "dddd", duration: 100, pace: 360, isDurationInSeconds: true)]),
    ];
  }
}
