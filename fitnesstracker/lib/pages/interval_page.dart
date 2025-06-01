import 'package:flutter/material.dart';
import '../model/running_interval.dart';
import '../model/running_plan.dart'; 

class IntervalPage extends StatefulWidget {
  final RunningPlanData runningPlan;
  final int intervalIndex;

  IntervalPage({
    required this.runningPlan,
    required this.intervalIndex,
  });

  @override
  _IntervalPageState createState() => _IntervalPageState();
}

class _IntervalPageState extends State<IntervalPage> {
  late RunningIntervalData interval;
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _paceMinutesController;
  late TextEditingController _paceSecondsController;
  bool isDurationInSeconds = true;

  @override
  void initState() {
    super.initState();
    interval = widget.runningPlan.intervals[widget.intervalIndex];

    // Initialize controllers with existing interval data
    _nameController = TextEditingController(text: interval.name.toString());
    _durationController = TextEditingController(text: interval.duration.toString());
    _paceMinutesController = TextEditingController(text: (interval.pace ~/ 60).toString());
    _paceSecondsController = TextEditingController(text: (interval.pace % 60).toString());
    isDurationInSeconds = interval.isDurationInSeconds;
  }

  bool _isUniqueName(String name) {
    return !widget.runningPlan.intervals
        .any((i) => i.name == name && i != interval);
  }

  void _saveInterval() {
    final name = _nameController.text;
    final duration = int.tryParse(_durationController.text) ?? 0;
    final paceMinutes = int.tryParse(_paceMinutesController.text) ?? 0;
    final paceSeconds = int.tryParse(_paceSecondsController.text) ?? 0;

    if (!_isUniqueName(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name must be unique")),
      );
      return;
    }

    // setState(() {
    //   interval.name = name;
    //   interval.duration = duration;
    //   interval.isDurationInSeconds = isDurationInSeconds;
    //   interval.pace = (paceMinutes * 60) + paceSeconds;
    // });

    Navigator.pop(context, true); // Return true to indicate a successful save
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Interval"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Interval Name"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: isDurationInSeconds ? "Duration (seconds)" : "Distance (meters)",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Switch(
                  value: isDurationInSeconds,
                  onChanged: (value) {
                    setState(() {
                      isDurationInSeconds = value;
                    });
                  },
                ),
                Text(isDurationInSeconds ? "Seconds" : "Meters"),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paceMinutesController,
                    decoration: InputDecoration(labelText: "Pace Minutes"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _paceSecondsController,
                    decoration: InputDecoration(labelText: "Pace Seconds"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _saveInterval,
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
