import 'package:fitnesstracker/model/running_interval.dart';
import 'package:drift/drift.dart';

@DataClassName('RunningPlanData')
class RunningPlans extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}
