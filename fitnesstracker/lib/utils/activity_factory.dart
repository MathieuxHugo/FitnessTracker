import '../model/activity_data.dart';
import '../model/exercise.dart';
import '../model/position_data.dart';

class ActivityFactory {
  /// Creates a sample running activity with mock data
  static ActivityData createSampleRunningActivity() {
    DateTime startTime = DateTime.now().subtract(const Duration(hours: 1));
    DateTime endTime = DateTime.now();
    
    // Create sample position data for a 5km run
    List<PositionData> positions = [
      PositionData(
        latitude: 40.7128,
        longitude: -74.0060,
        time: 0,
        distance: 0.0,
        accuracy: 5.0,
        currentSpeed: 0.0,
        speedAccuracy: 1.0,
      ),
      PositionData(
        latitude: 40.7138,
        longitude: -74.0070,
        time: 300, // 5 minutes
        distance: 500.0, // 500 meters
        accuracy: 5.0,
        currentSpeed: 1.67, // ~6 km/h
        speedAccuracy: 1.0,
      ),
      PositionData(
        latitude: 40.7148,
        longitude: -74.0080,
        time: 600, // 10 minutes
        distance: 1000.0, // 1 km
        accuracy: 5.0,
        currentSpeed: 1.67,
        speedAccuracy: 1.0,
      ),
      PositionData(
        latitude: 40.7158,
        longitude: -74.0090,
        time: 1800, // 30 minutes
        distance: 5000.0, // 5 km
        accuracy: 5.0,
        currentSpeed: 1.67,
        speedAccuracy: 1.0,
      ),
    ];

    RunningExercise runningExercise = RunningExercise(
      id: "${DateTime.now().toIso8601String()}_running_sample",
      startTime: startTime,
      endTime: endTime,
      duration: 1800, // 30 minutes
      positions: positions,
      totalDistance: 5000.0, // 5 km
      averageSpeed: 1.67, // ~6 km/h
      averagePace: "10:00", // 10 minutes per km
    );

    return ActivityData(
      id: DateTime.now().toIso8601String(),
      startTime: startTime,
      endTime: endTime,
      exercises: [runningExercise],
      totalTime: 1800,
      name: "Morning Run",
      description: "5km morning jog in the park",
    );
  }

  /// Creates a sample weightlifting activity
  static ActivityData createSampleWeightliftingActivity() {
    DateTime startTime = DateTime.now().subtract(const Duration(hours: 2));
    DateTime endTime = DateTime.now().subtract(const Duration(hours: 1));

    // Create bench press exercise
    WeightliftingExercise benchPress = WeightliftingExercise(
      id: "${DateTime.now().toIso8601String()}_bench_press",
      startTime: startTime,
      endTime: startTime.add(const Duration(minutes: 15)),
      duration: 900, // 15 minutes
      exerciseName: "Bench Press",
      sets: [
        WeightliftingSet(weight: 60.0, reps: 12, exertionLevel: 6),
        WeightliftingSet(weight: 70.0, reps: 10, exertionLevel: 7),
        WeightliftingSet(weight: 80.0, reps: 8, exertionLevel: 8),
        WeightliftingSet(weight: 85.0, reps: 6, exertionLevel: 9),
      ],
    );

    // Create squat exercise
    WeightliftingExercise squats = WeightliftingExercise(
      id: "${DateTime.now().toIso8601String()}_squats",
      startTime: startTime.add(const Duration(minutes: 20)),
      endTime: endTime,
      duration: 2400, // 40 minutes
      exerciseName: "Squats",
      sets: [
        WeightliftingSet(weight: 80.0, reps: 12, exertionLevel: 6),
        WeightliftingSet(weight: 90.0, reps: 10, exertionLevel: 7),
        WeightliftingSet(weight: 100.0, reps: 8, exertionLevel: 8),
        WeightliftingSet(weight: 110.0, reps: 6, exertionLevel: 9),
        WeightliftingSet(weight: 120.0, reps: 4, exertionLevel: 10),
      ],
    );

    return ActivityData(
      id: DateTime.now().toIso8601String(),
      startTime: startTime,
      endTime: endTime,
      exercises: [benchPress, squats],
      totalTime: 3600, // 1 hour
      name: "Upper Body Strength Training",
      description: "Bench press and squats workout session",
    );
  }

  /// Creates a mixed activity with both running and weightlifting
  static ActivityData createSampleMixedActivity() {
    DateTime startTime = DateTime.now().subtract(const Duration(hours: 3));
    DateTime midTime = DateTime.now().subtract(const Duration(hours: 2));
    DateTime endTime = DateTime.now().subtract(const Duration(hours: 1));

    // Warm-up run
    List<PositionData> warmupPositions = [
      PositionData(
        latitude: 40.7128,
        longitude: -74.0060,
        time: 0,
        distance: 0.0,
        accuracy: 5.0,
        currentSpeed: 0.0,
        speedAccuracy: 1.0,
      ),
      PositionData(
        latitude: 40.7138,
        longitude: -74.0070,
        time: 600, // 10 minutes
        distance: 1000.0, // 1 km warmup
        accuracy: 5.0,
        currentSpeed: 1.67,
        speedAccuracy: 1.0,
      ),
    ];

    RunningExercise warmupRun = RunningExercise(
      id: "${DateTime.now().toIso8601String()}_warmup_run",
      startTime: startTime,
      endTime: startTime.add(const Duration(minutes: 10)),
      duration: 600,
      positions: warmupPositions,
      totalDistance: 1000.0,
      averageSpeed: 1.67,
      averagePace: "10:00",
    );

    // Strength training
    WeightliftingExercise deadlifts = WeightliftingExercise(
      id: "${DateTime.now().toIso8601String()}_deadlifts",
      startTime: midTime,
      endTime: endTime,
      duration: 3600, // 1 hour
      exerciseName: "Deadlifts",
      sets: [
        WeightliftingSet(weight: 100.0, reps: 8, exertionLevel: 7),
        WeightliftingSet(weight: 120.0, reps: 6, exertionLevel: 8),
        WeightliftingSet(weight: 140.0, reps: 4, exertionLevel: 9),
        WeightliftingSet(weight: 160.0, reps: 2, exertionLevel: 10),
      ],
    );

    return ActivityData(
      id: DateTime.now().toIso8601String(),
      startTime: startTime,
      endTime: endTime,
      exercises: [warmupRun, deadlifts],
      totalTime: 4200, // 70 minutes total
      name: "Full Body Workout",
      description: "Warmup run followed by deadlift strength training",
    );
  }
}