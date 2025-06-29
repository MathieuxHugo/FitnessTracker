import 'package:fitnesstracker/model/running_interval.dart';

import '../model/running_plan.dart';

import 'package:fitnesstracker/repository/json_repository.dart';

class RunningPlansService {
  final JsonRepository _repository;

  RunningPlansService(this._repository);

  Future<List<RunningPlanData>> getRunningPlans() async {
    return _repository.retrieveRunningPlans();
  }

  Future<void> saveRunningPlan(RunningPlanData plan) async {
    await _repository.saveRunningPlan(plan);
  }
}
