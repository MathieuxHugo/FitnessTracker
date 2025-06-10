import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/position_data.dart';
import '../model/activity_data.dart';
import 'dart:developer';

class ActivityRepository {
  static final ActivityRepository _instance = ActivityRepository._internal();
  factory ActivityRepository() => _instance;
  ActivityRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activity_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        startTime TEXT,
        totalDistance REAL,
        totalTime INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE positions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activityId TEXT,
        latitude REAL,
        longitude REAL,
        time INTEGER,
        distance REAL,
        accuracy REAL,
        speedAccuracy REAL,
        currentSpeed REAL,
        FOREIGN KEY (activityId) REFERENCES activities(id) ON DELETE CASCADE
      )
    ''');
  }

  // Save an Activity and its Positions
  Future<void> saveActivity(ActivityData activity) async {
    final db = await database;

    // Insert activity details
    await db.insert(
      'activities',
      {
        'id': activity.id,
        'startTime': activity.startTime.toIso8601String(),
        'totalDistance': activity.totalDistance,
        'totalTime': activity.totalTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert all position data for the activity
    for (var position in activity.positions) {
      await db.insert(
        'positions',
        {
          'activityId': activity.id,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'time': position.time,
          'distance': position.distance,
          'accuracy': position.accuracy,
          'speedAccuracy': position.speedAccuracy,
          'currentSpeed': position.currentSpeed,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Retrieve all Activities with associated PositionData
  Future<List<ActivityData>> retrieveActivities() async {
    final db = await database;

    // Get all activities
    final activityMaps = await db.query('activities');
    List<ActivityData> activities = [];

    for (var activityMap in activityMaps) {
      // Get associated positions for each activity
      final positionMaps = await db.query(
        'positions',
        where: 'activityId = ?',
        whereArgs: [activityMap['id']],
      );

      List<PositionData> positions = positionMaps.map((pos) {
        return PositionData(
          latitude: pos['latitude'] as double,
          longitude: pos['longitude'] as double,
          time: pos['time'] as int,
          distance: pos['distance'] as double,
          accuracy: pos['accuracy'] as double,
          speedAccuracy: pos['speedAccuracy'] as double,
          currentSpeed: pos['currentSpeed'] as double,
        );
      }).toList();

      activities.add(ActivityData(
        id: activityMap['id'] as String,
        startTime: DateTime.parse(activityMap['startTime'] as String),
        positions: positions,
        totalDistance: activityMap['totalDistance'] as double,
        totalTime: activityMap['totalTime'] as int,
      ));
    }

    return activities;
  }

  // Optional: Clear all data (for testing or resetting)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('activities');
    await db.delete('positions');
  }
}
