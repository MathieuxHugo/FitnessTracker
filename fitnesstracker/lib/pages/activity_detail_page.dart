import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/activity_data.dart';
import '../model/position_data.dart';
import 'run_map_page.dart';

class ActivityDetailPage extends StatefulWidget {
  final ActivityData activity;

  const ActivityDetailPage({required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  double paceInterval = 20;
  double speedThreshold = 1.5, accuracyThreshold = 30;
  double maxSpeedThreshold = 5, maxAccuracyThreshold = 50;
  int minPace = 4;
  List<int> pacePerKm = [];
  List<PositionData> outliers = [];
  double totalDistance = 0;
  int totalTime = 0;

  String thresholdParameter = "Min speed";
  List<DropdownMenuEntry> parameters = [
    DropdownMenuEntry(value: "Accuracy", label: "Accuracy"),
    DropdownMenuEntry(value: "Speed accuracy", label: "Speed accuracy"),
    DropdownMenuEntry(value: "Min speed", label: "Min speed")
  ];

  _getTitlesKM(double value, TitleMeta meta) {
    if (value.toInt() % (pacePerKm.length / 8.0).floor() == 0) {
      return Text('${value.toInt() + 1}');
    } else {
      return SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Speed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: maxSpeedThreshold,
              divisions: 10,
              value: speedThreshold,
              label: speedThreshold.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  speedThreshold = value;
                  _updateValues();
                });
              },
            ),
            Text(
              'Accuracy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: maxAccuracyThreshold,
              divisions: 10,
              value: accuracyThreshold,
              label: accuracyThreshold.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  accuracyThreshold = value;
                  _updateValues();
                });
              },
            ),
            Text(
              "Ratio outliers: ${(outliers.length / widget.activity.positions.length).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Total Distance: ${(totalDistance / 1000).toStringAsFixed(3)} km",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Total Time: ${_formatDuration(totalTime)}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Average Pace: ${_formatDuration(((totalTime / (totalDistance / 1000)).floor()))} min/km",
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),

            // Pace per km Bar Chart
            Text(
              'Pace per Kilometer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  minY: 1.0 * minPace,
                  barGroups: pacePerKm
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: 1.0 * entry.value,
                              color: Colors.blue,
                              width: 10,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            _getTitlesKM(value, meta),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            _getTitlesKM(value, meta),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: paceInterval,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(_formatDuration(value.floor()));
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: paceInterval,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(_formatDuration(value.floor()));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Outliers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              itemCount: outliers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final outlier = outliers[index];
                return ListTile(
                  title: Text("Accuracy : ${outlier.accuracy}"),
                  subtitle: Text(
                      "Meter: ${outlier.distance}m\nTime: ${widget.activity.startTime.add(Duration(seconds: outlier.time))}"),
                  isThreeLine: true,
                  onTap: () {},
                );
              },
            ),
            //RunMapPage(positions: widget.activity.positions),
          ],
        ),
      ),
    );
  }

  // Format duration in hh:mm:ss
  String _formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return [if (hours > 0) hours, minutes, seconds]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
  }

  // Format pace in min/km
  String _formatPace(double speed) {
    if (speed != 0) {
      return _formatDuration((1000 / speed).floor());
    } else {
      return "--:--";
    }
  }

  void _updateValues() {
    pacePerKm = [];
    outliers = [];
    int previousTime = 0;
    PositionData prevPosition = widget.activity.positions.first;
    minPace = 1000;
    totalTime = 0;
    totalDistance = 0;
    for (PositionData position in widget.activity.positions) {
      if (!applyThreshold(position, prevPosition)) {
        outliers.add(position);
      } else {
        int timeSinceLast = position.time - prevPosition.time;
        totalTime += timeSinceLast;
        totalDistance += position.distance - prevPosition.distance;
        if (totalDistance >= (pacePerKm.length + 1) * 1000) {
          int pace = (totalTime - previousTime);
          minPace = min(minPace, pace);
          pacePerKm.add(pace); // Convert seconds to minutes for pace
          previousTime = totalTime; // Reset for the next kilometer
        }
      }
      prevPosition = position;
    }

    if ((totalDistance) % 1000 > 200) {
      pacePerKm.add(
          ((totalTime - previousTime) / (((totalDistance) % 1000) / 1000))
              .floor()); // Add final segment if incomplete km
    }
  }

  bool applyThreshold(PositionData position, PositionData prevPosition) {
    return ((1.0 * position.distance - prevPosition.distance) /
                (position.time - prevPosition.time) >
            speedThreshold) &&
        position.accuracy < accuracyThreshold;
  }
}
