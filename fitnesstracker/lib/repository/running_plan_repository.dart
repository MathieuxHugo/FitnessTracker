import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/running_interval.dart';
import '../model/running_plan.dart';

class RunningPlanRepository {
  static final RunningPlanRepository _instance = RunningPlanRepository._internal();
  factory RunningPlanRepository() => _instance;
  RunningPlanRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'running_plan_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE running_plans (
        name TEXT PRIMARY KEY,
        intervals TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE running_intervals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        planName TEXT,
        name TEXT,
        duration INTEGER,
        isDurationInSeconds INTEGER,
        pace INTEGER,
        FOREIGN KEY (planName) REFERENCES running_plans(name) ON DELETE CASCADE
      )
    ''');
  }

  // Save a RunningPlan and its Intervals
  Future<void> saveRunningPlan(RunningPlan plan) async {
    final db = await database;

    // Insert running plan details
    await db.insert(
      'running_plans',
      {'name': plan.name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert all intervals for the running plan
    for (var interval in plan.intervals) {
      await db.insert(
        'running_intervals',
        {
          'planName': plan.name,
          'name': interval.name,
          'duration': interval.duration,
          'isDurationInSeconds': interval.isDurationInSeconds ? 1 : 0,
          'pace': interval.pace,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Retrieve all RunningPlans with associated RunningIntervals
  Future<List<RunningPlan>> retrieveRunningPlans() async {
    final db = await database;

    // Get all running plans
    final planMaps = await db.query('running_plans');
    List<RunningPlan> runningPlans = [];

    for (var planMap in planMaps) {
      // Get associated intervals for each plan
      final intervalMaps = await db.query(
        'running_intervals',
        where: 'planName = ?',
        whereArgs: [planMap['name']],
      );

      List<RunningInterval> intervals = intervalMaps.map((interval) {
        return RunningInterval(
          name: interval['name'] as String,
          duration: interval['duration'] as int,
          isDurationInSeconds: (interval['isDurationInSeconds'] as int) == 1,
          pace: interval['pace'] as int,
        );
      }).toList();

      runningPlans.add(RunningPlan(
        name: planMap['name'] as String,
        intervals: intervals,
      ));
    }

    return runningPlans;
  }

  // Optional: Clear all data (for testing or resetting)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('running_plans');
    await db.delete('running_intervals');
  }
}
