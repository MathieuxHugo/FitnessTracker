import 'package:fitnesstracker/model/running_interval.dart';

import '../model/running_plan.dart';

class RunningPlansService {
  Future<List<RunningPlan>> getRunningPlans() async {
    // Mock data for now
    return [
      RunningPlan(id: "1", name: "5K Training Plan", intervals:[RunningInterval(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: true), RunningInterval(name: "dddd", duration:200, pace: 360, isDurationInSeconds: true)]),
      RunningPlan(id: "2", name: "Marathon Prep", intervals : [RunningInterval(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: false), RunningInterval(name: "dddd", duration: 360, pace: 360, isDurationInSeconds: true)]),
      RunningPlan(id: "3", name: "Interval Training", intervals:[RunningInterval(name: "fdfsdf", duration: 300, pace: 420, isDurationInSeconds: true), RunningInterval(name: "dddd", duration: 100, pace: 360, isDurationInSeconds: true)]),
    ];
  }
}
