import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/Activity.dart';
import '../model/PositionData.dart';
import 'run_map_page.dart';


class ActivityDetailPage extends StatefulWidget{

  final Activity activity;
  const ActivityDetailPage({required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();

}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  double avgSpeed = 0.0;
  double threshold = 10.5;
  List<double> pacePerKm = [];
  List<PositionData> outliers = [];

  @override
  Widget build(BuildContext context) {
    _updateValues();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Slider(
              min: 1,
              max: 20,
              divisions: 20,
              value: threshold,
              label: threshold.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  threshold = value;
                });
              },
            ),
            Text(
              "Ratio outliers: ${(outliers.length/widget.activity.positions.length).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Total Distance: ${(widget.activity.totalDistance / 1000)
                  .toStringAsFixed(3)} km",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Total Time: ${_formatDuration(-widget.activity.totalTime)}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Average Pace: ${_formatDuration((-widget.activity.totalTime /
                  (widget.activity.totalDistance / 1000))
                  .floor())} min/km or ${_formatPace(avgSpeed)}",
              style: TextStyle(fontSize: 18),
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
                  barGroups: pacePerKm
                      .asMap()
                      .entries
                      .map(
                        (entry) =>
                        BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Colors.blue,
                              width: 20,
                            ),
                          ],
                        ),
                  )
                      .toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('${value.toInt() + 1} km');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('${value.toStringAsFixed(1)}');
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
                  title: Text("Speed : ${outlier.currentSpeed}"),
                  subtitle: Text(
                      "Meter: ${outlier.distance}m\nAccuracy: ${outlier
                          .accuracy}m/s"),
                  isThreeLine: true,
                  onTap: () {},
                );
              },
            ),
            RunMapPage(positions: widget.activity.positions),
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
    return [if (hours > 0) hours, minutes, seconds].map((e) =>
        e.toString().padLeft(2, '0')).join(':');
  }

  // Format pace in min/km
  String _formatPace(double speed) {
    if (speed!=0){
      return _formatDuration((1000 / speed).floor());
    }
    else{
      return "--:--";
    }
  }

  void _updateValues() {
    pacePerKm = [];
    outliers = [];
    avgSpeed = 0.0;
    int cpt = 0;
    int previousTime = 0;
    double speedPrevDistance = 0;
    int speedPrevTime = 0;
    for (PositionData position in widget.activity.positions) {
      if (position.accuracy > threshold) {
        outliers.add(position);
      }
      else {
        cpt++;
        if(position.time!=speedPrevTime){
          avgSpeed += (position.distance-speedPrevDistance)/(position.time-speedPrevTime);
        }
        speedPrevTime = position.time;
        speedPrevDistance = position.distance;
        if (position.distance >= (pacePerKm.length + 1) * 1000) {
          pacePerKm.add((position.time - previousTime) /
              60.0); // Convert seconds to minutes for pace
          previousTime = position.time; // Reset for the next kilometer
        }
      }
    }
    PositionData last = widget.activity.positions.last;
    if (last.distance % 1000 > 200) {
      pacePerKm.add(
          ((widget.activity.positions.last.time - previousTime) / 60.0) /
              ((last.distance % 1000) /
                  1000)); // Add final segment if incomplete km
    }
    avgSpeed = (cpt<=1)?0:(-avgSpeed / (cpt-1));
  }
}
