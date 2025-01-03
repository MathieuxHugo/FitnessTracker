import 'package:fitnesstracker/service/activity_service.dart';
import 'package:flutter/material.dart';

import '../model/activity_data.dart';
import '../repository/activity_repository.dart';
import 'activity_detail_page.dart';

class PreviousActivitiesPage extends StatefulWidget {
  @override
  _PreviousActivitiesPageState createState() => _PreviousActivitiesPageState();
}

class _PreviousActivitiesPageState extends State<PreviousActivitiesPage> {
  List<ActivityData> _activities = [];

  ActivityService activityService = ActivityService();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    // Fetch activities from the database
    List<ActivityData> activities = await activityService.getAllActivities();
    setState(() {
      _activities = activities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Activities'),
      ),
      body: _activities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return ListTile(
            title: Text("Activity ID: ${activity.id}"),
            subtitle: Text(
                "Start Time: ${activity.startTime.toLocal()}\nTotal Distance: ${(activity.totalDistance/1000).toStringAsFixed(3)} km"),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityDetailPage(activity: activity),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
