import 'package:drift/drift.dart';

@DataClassName('RunningIntervalData')
class RunningIntervals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get planName =>
      text().customConstraint('REFERENCES running_plans(name)')();
  TextColumn get name => text()();
  IntColumn get duration => integer()(); // Either in seconds or meters
  BoolColumn get isDurationInSeconds => boolean()();
  IntColumn get pace => integer()(); // In seconds
}
