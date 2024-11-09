import 'package:flutter/material.dart';
import 'package:reorderable_list/reorderable_list.dart';
import 'dart:math'; // For generating random IDs

import '../model/running_interval.dart';
import '../model/running_plan.dart';
import 'interval_page.dart';

class RunningPlanPage extends StatefulWidget {
  final RunningPlan runningPlan;
  const RunningPlanPage({required this.runningPlan});

  @override
  _RunningPlanPageState createState() => _RunningPlanPageState();
}

class _RunningPlanPageState extends State<RunningPlanPage> {
  final TextEditingController _planNameController = TextEditingController();

  void _addInterval() {
    int length =widget.runningPlan.intervals.length;
    widget.runningPlan.intervals.add(RunningInterval(name: "Interval ${length+1}", duration: 300, isDurationInSeconds: true, pace: 360));
    _navigateToInterval(length);
  }

  void _navigateToInterval(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntervalPage(intervalIndex: index, runningPlan: widget.runningPlan),
      ),
    );
  }


  void _deleteInterval(int index) {
    setState(() {
      widget.runningPlan.intervals.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _planNameController.text=widget.runningPlan.name;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Running Plan"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _planNameController,
              decoration: InputDecoration(
                labelText: "Plan Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ReorderableList(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final interval = widget.runningPlan.intervals.removeAt(oldIndex);
                  widget.runningPlan.intervals.insert(newIndex, interval);
                });
              },
              itemCount: widget.runningPlan.intervals.length,
              itemBuilder: (context, index) {
                final interval = widget.runningPlan.intervals[index];
                return Dismissible(
                  key: ValueKey(interval.name),
                  onDismissed: (_) => _deleteInterval(index),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.drag_handle),
                      title: Text(interval.name),
                      onTap: () => _navigateToInterval(index),
                      subtitle: Text(
                          "Duration: ${_displayDuration(interval)}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteInterval(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addInterval,
        child: Icon(Icons.add),
      ),
    );
  }

  _displayDuration(RunningInterval interval) {
    return interval.isDurationInSeconds ? "${(interval.duration/60).floor()}:${interval.duration%60}":"${interval.duration}m";
  }
}
