import 'dart:convert';
import 'package:fitnesstracker/service/json_storage_service.dart';
import '../model/activity_data.dart';
import '../model/running_plan.dart';

class JsonRepository {
  final JsonStorageService _storageService;
  static const String _activityFileName = 'activities.json';
  static const String _runningPlanFileName = 'running_plans.json';

  JsonRepository(this._storageService);

  Future<void> saveActivity(ActivityData activity) async {
    final activities = await retrieveActivities();
    final index = activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      activities[index] = activity;
    } else {
      activities.add(activity);
    }
    await _storageService.writeData(
        _activityFileName, {'activities': activities.map((a) => a.toJson()).toList()});
  }

  Future<List<ActivityData>> retrieveActivities() async {
    final data = await _storageService.readData(_activityFileName);
    if (data != null && data['activities'] != null) {
      final activities = data['activities'] as List;
      return activities
          .map((json) => ActivityData.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
  
  Future<void> deleteActivity(String activityId) async {
    final activities = await retrieveActivities();
    activities.removeWhere((activity) => activity.id == activityId);
    await _storageService.writeData(
        _activityFileName, {'activities': activities.map((a) => a.toJson()).toList()});
  }

  Future<void> saveRunningPlan(RunningPlanData plan) async {
    final plans = await retrieveRunningPlans();
    final index = plans.indexWhere((p) => p.name == plan.name);
    if (index != -1) {
      plans[index] = plan;
    } else {
      plans.add(plan);
    }
    await _storageService.writeData(_runningPlanFileName,
        {'running_plans': plans.map((p) => p.toJson()).toList()});
  }

  Future<List<RunningPlanData>> retrieveRunningPlans() async {
    final data = await _storageService.readData(_runningPlanFileName);
    if (data != null && data['running_plans'] != null) {
      final plans = data['running_plans'] as List;
      return plans
          .map((json) => RunningPlanData.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}