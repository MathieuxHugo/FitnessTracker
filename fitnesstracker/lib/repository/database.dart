import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../model/running_interval.dart';
import '../model/running_plan.dart';

part 'database.g.dart';

@DriftDatabase(tables: [RunningPlans, RunningIntervals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  // Insert a running plan
  Future<void> insertRunningPlan(
      RunningPlans plan, List<RunningIntervals> intervals) async {
    await into(runningPlans).insert(plan);
    await batch((batch) {
      batch.insertAll(runningIntervals, intervals);
    });
  }

  // Retrieve all running plans with their intervals
  Future<List<RunningPlanWithIntervals>> getRunningPlansWithIntervals() async {
    final query = select(runningPlans).join([
      leftOuterJoin(runningIntervals,
          runningIntervals.planName.equalsExp(runningPlans.name)),
    ]);

    final rows = await query.get();

    final Map<String, List<RunningIntervals>> intervalsMap = {};

    for (final row in rows) {
      final plan = row.readTable(runningPlans);
      final interval = row.readTableOrNull(runningIntervals);

      if (interval != null) {
        intervalsMap.putIfAbsent(plan.name, () => []).add(interval);
      }
    }

    return intervalsMap.entries
        .map((entry) => RunningPlanWithIntervals(
              plan: RunningPlans(name: entry.key),
              intervals: entry.value,
            ))
        .toList();
  }
}

// Helper class to represent a plan with its intervals
class RunningPlanWithIntervals {
  final RunningPlans plan;
  final List<RunningIntervals> intervals;

  RunningPlanWithIntervals({required this.plan, required this.intervals});
}
