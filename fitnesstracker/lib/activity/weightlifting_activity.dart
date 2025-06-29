import 'dart:async';
import 'dart:developer';

import 'package:fitnesstracker/activity/activity.dart';
import 'package:fitnesstracker/repository/json_repository.dart';
import 'package:fitnesstracker/model/exercise.dart';
import 'package:fitnesstracker/model/activity_data.dart';
import 'package:flutter/material.dart';

class WeightliftingActivity extends Activity {
  String exerciseName;
  List<WeightliftingSet> sets = [];
  DateTime? startTime;
  DateTime? currentSetStartTime;
  
  WeightliftingActivity({
    required this.exerciseName,
    required JsonRepository repository,
  }) : super(repository);

  void addSet(double weight, int reps, int exertionLevel) {
    sets.add(WeightliftingSet(
      weight: weight,
      reps: reps,
      exertionLevel: exertionLevel,
    ));
  }

  void removeLastSet() {
    if (sets.isNotEmpty) {
      sets.removeLast();
    }
  }

  List<WeightliftingSet> getSets() {
    return List.from(sets);
  }

  String getExerciseName() {
    return exerciseName;
  }

  int getTotalSets() {
    return sets.length;
  }

  double getTotalWeight() {
    return sets.fold(0.0, (sum, set) => sum + (set.weight * set.reps));
  }

  @override
  Future<void> save() async {
    if (startTime == null) {
      throw "Activity not started";
    }
    
    DateTime endTime = DateTime.now();
    
    WeightliftingExercise weightliftingExercise = WeightliftingExercise(
      id: "${DateTime.now().toIso8601String()}_weightlifting",
      startTime: startTime!,
      endTime: endTime,
      duration: endTime.difference(startTime!).inSeconds,
      exerciseName: exerciseName,
      sets: sets,
    );
    
    ActivityData activity = ActivityData(
      id: DateTime.now().toIso8601String(),
      startTime: startTime!,
      endTime: endTime,
      exercises: [weightliftingExercise],
      totalTime: endTime.difference(startTime!).inSeconds,
      name: "$exerciseName Workout",
      description: "Weightlifting session with ${sets.length} sets",
    );
    
    await activityService.saveActivity(activity);
  }

  @override
  Future<void> start() async {
    startTime = DateTime.now();
  }

  @override
  void pause() {
    // Weightlifting doesn't need pause functionality in the same way
    // Could be used to pause rest timer if implemented
  }

  @override
  void resume() {
    // Weightlifting doesn't need resume functionality in the same way
  }

  @override
  Widget getActivityWidget() {
    return WeightliftingWidget(activity: this);
  }
}

// Simple weightlifting widget - you can expand this
class WeightliftingWidget extends StatefulWidget {
  final WeightliftingActivity activity;

  const WeightliftingWidget({Key? key, required this.activity}) : super(key: key);

  @override
  _WeightliftingWidgetState createState() => _WeightliftingWidgetState();
}

class _WeightliftingWidgetState extends State<WeightliftingWidget> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  int _exertionLevel = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.activity.getExerciseName(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Total Sets: ${widget.activity.getTotalSets()}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Total Weight: ${widget.activity.getTotalWeight().toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _repsController,
            decoration: const InputDecoration(
              labelText: 'Reps',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Text('Exertion Level: $_exertionLevel'),
          Slider(
            value: _exertionLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _exertionLevel.toString(),
            onChanged: (value) {
              setState(() {
                _exertionLevel = value.round();
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _addSet,
                  child: const Text('Add Set'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.activity.getTotalSets() > 0 ? _removeLastSet : null,
                  child: const Text('Remove Last'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.activity.getSets().length,
              itemBuilder: (context, index) {
                final set = widget.activity.getSets()[index];
                return Card(
                  child: ListTile(
                    title: Text('Set ${index + 1}'),
                    subtitle: Text('${set.weight}kg × ${set.reps} reps'),
                    trailing: Text('RPE: ${set.exertionLevel}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addSet() {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);
    
    if (weight != null && reps != null && weight > 0 && reps > 0) {
      setState(() {
        widget.activity.addSet(weight, reps, _exertionLevel);
        _weightController.clear();
        _repsController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weight and reps')),
      );
    }
  }

  void _removeLastSet() {
    setState(() {
      widget.activity.removeLastSet();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }
}