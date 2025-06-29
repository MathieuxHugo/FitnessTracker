import '../model/activity_data.dart';
import '../model/exercise.dart';
import '../utils/activity_factory.dart';

/// This file demonstrates how to use the new exercise-based activity system
void demonstrateNewActivityStructure() {
  print("=== New Activity Data Structure Examples ===\n");

  // Example 1: Running Activity
  print("1. Running Activity Example:");
  ActivityData runningActivity = ActivityFactory.createSampleRunningActivity();
  
  print("   Activity: ${runningActivity.name}");
  print("   Description: ${runningActivity.description}");
  print("   Total Time: ${runningActivity.totalTime} seconds");
  print("   Number of Exercises: ${runningActivity.exercises.length}");
  
  // Access running-specific data
  List<RunningExercise> runningExercises = runningActivity.runningExercises;
  if (runningExercises.isNotEmpty) {
    RunningExercise firstRun = runningExercises.first;
    print("   Running Distance: ${firstRun.totalDistance}m");
    print("   Average Pace: ${firstRun.averagePace}");
    print("   Number of GPS Points: ${firstRun.positions.length}");
  }
  
  // Backward compatibility - can still access positions like before
  print("   Total Positions (backward compatibility): ${runningActivity.positions.length}");
  print("   Total Distance (backward compatibility): ${runningActivity.totalDistance}m\n");

  // Example 2: Weightlifting Activity
  print("2. Weightlifting Activity Example:");
  ActivityData weightliftingActivity = ActivityFactory.createSampleWeightliftingActivity();
  
  print("   Activity: ${weightliftingActivity.name}");
  print("   Description: ${weightliftingActivity.description}");
  print("   Total Time: ${weightliftingActivity.totalTime} seconds");
  print("   Number of Exercises: ${weightliftingActivity.exercises.length}");
  
  // Access weightlifting-specific data
  List<WeightliftingExercise> weightExercises = weightliftingActivity.weightliftingExercises;
  for (int i = 0; i < weightExercises.length; i++) {
    WeightliftingExercise exercise = weightExercises[i];
    print("   Exercise ${i + 1}: ${exercise.exerciseName}");
    print("     Sets: ${exercise.sets.length}");
    
    double totalWeight = 0;
    int totalReps = 0;
    for (WeightliftingSet set in exercise.sets) {
      totalWeight += set.weight * set.reps;
      totalReps += set.reps;
      print("     - ${set.weight}kg × ${set.reps} reps (RPE: ${set.exertionLevel})");
    }
    print("     Total Volume: ${totalWeight}kg");
    print("     Total Reps: $totalReps");
  }
  print("");

  // Example 3: Mixed Activity (Running + Weightlifting)
  print("3. Mixed Activity Example:");
  ActivityData mixedActivity = ActivityFactory.createSampleMixedActivity();
  
  print("   Activity: ${mixedActivity.name}");
  print("   Description: ${mixedActivity.description}");
  print("   Total Time: ${mixedActivity.totalTime} seconds");
  print("   Number of Exercises: ${mixedActivity.exercises.length}");
  
  print("   Exercise Breakdown:");
  for (int i = 0; i < mixedActivity.exercises.length; i++) {
    Exercise exercise = mixedActivity.exercises[i];
    print("     ${i + 1}. ${exercise.type.toUpperCase()} (${exercise.duration}s)");
    
    if (exercise is RunningExercise) {
      print("        Distance: ${exercise.totalDistance}m");
      print("        Average Pace: ${exercise.averagePace}");
    } else if (exercise is WeightliftingExercise) {
      print("        Exercise: ${exercise.exerciseName}");
      print("        Sets: ${exercise.sets.length}");
    }
  }
  
  print("   Running Summary: ${mixedActivity.runningExercises.length} running exercises");
  print("   Weightlifting Summary: ${mixedActivity.weightliftingExercises.length} weightlifting exercises");
  print("   Total Running Distance: ${mixedActivity.totalDistance}m\n");

  // Example 4: JSON Serialization
  print("4. JSON Serialization Example:");
  Map<String, dynamic> json = runningActivity.toJson();
  print("   JSON keys: ${json.keys.join(', ')}");
  
  // Deserialize back
  ActivityData deserializedActivity = ActivityData.fromJson(json);
  print("   Deserialized activity name: ${deserializedActivity.name}");
  print("   Deserialized exercises count: ${deserializedActivity.exercises.length}");
  print("");

  print("=== Key Benefits of New Structure ===");
  print("✓ Activities can contain multiple exercises of different types");
  print("✓ Each exercise type has specific data (GPS for running, sets/reps for weightlifting)");
  print("✓ Backward compatibility maintained for existing code");
  print("✓ Easy to extend with new exercise types");
  print("✓ Better organization and data modeling");
  print("✓ JSON serialization works seamlessly");
}

/// Example of how to create a custom workout programmatically
ActivityData createCustomWorkout() {
  DateTime startTime = DateTime.now();
  
  // Create a warm-up run
  RunningExercise warmup = RunningExercise(
    id: "warmup_${DateTime.now().millisecondsSinceEpoch}",
    startTime: startTime,
    endTime: startTime.add(const Duration(minutes: 10)),
    duration: 600,
    positions: [], // Would be populated with real GPS data
    totalDistance: 800.0, // 800m warmup
    averageSpeed: 1.33, // ~5 km/h easy pace
    averagePace: "12:30",
  );
  
  // Create strength exercises
  WeightliftingExercise pushups = WeightliftingExercise(
    id: "pushups_${DateTime.now().millisecondsSinceEpoch}",
    startTime: startTime.add(const Duration(minutes: 15)),
    endTime: startTime.add(const Duration(minutes: 25)),
    duration: 600,
    exerciseName: "Push-ups",
    sets: [
      WeightliftingSet(weight: 0, reps: 20, exertionLevel: 6), // Bodyweight
      WeightliftingSet(weight: 0, reps: 18, exertionLevel: 7),
      WeightliftingSet(weight: 0, reps: 15, exertionLevel: 8),
    ],
  );
  
  WeightliftingExercise pullups = WeightliftingExercise(
    id: "pullups_${DateTime.now().millisecondsSinceEpoch}",
    startTime: startTime.add(const Duration(minutes: 30)),
    endTime: startTime.add(const Duration(minutes: 40)),
    duration: 600,
    exerciseName: "Pull-ups",
    sets: [
      WeightliftingSet(weight: 0, reps: 8, exertionLevel: 7),
      WeightliftingSet(weight: 0, reps: 6, exertionLevel: 8),
      WeightliftingSet(weight: 0, reps: 4, exertionLevel: 9),
    ],
  );
  
  // Cool-down run
  RunningExercise cooldown = RunningExercise(
    id: "cooldown_${DateTime.now().millisecondsSinceEpoch}",
    startTime: startTime.add(const Duration(minutes: 45)),
    endTime: startTime.add(const Duration(minutes: 55)),
    duration: 600,
    positions: [], // Would be populated with real GPS data
    totalDistance: 600.0, // 600m cooldown
    averageSpeed: 1.11, // ~4 km/h recovery pace
    averagePace: "15:00",
  );
  
  return ActivityData(
    id: "custom_workout_${DateTime.now().millisecondsSinceEpoch}",
    startTime: startTime,
    endTime: startTime.add(const Duration(minutes: 55)),
    exercises: [warmup, pushups, pullups, cooldown],
    totalTime: 3300, // 55 minutes
    name: "Custom Circuit Training",
    description: "Warmup run, bodyweight strength training, and cooldown",
  );
}