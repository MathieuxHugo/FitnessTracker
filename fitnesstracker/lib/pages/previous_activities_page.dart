import 'package:fitnesstracker/repository/json_repository.dart';
import 'package:fitnesstracker/service/activity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/activity_data.dart';
import 'activity_detail_page.dart';

// Make the state class name public (without underscore) so it can be referenced from home_screen.dart
class PreviousActivitiesPage extends StatefulWidget {
  const PreviousActivitiesPage({Key? key}) : super(key: key);

  @override
  PreviousActivitiesPageState createState() => PreviousActivitiesPageState();
}

class PreviousActivitiesPageState extends State<PreviousActivitiesPage> {
  late ActivityService _activityService;
  List<ActivityData> _activities = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final jsonRepository = Provider.of<JsonRepository>(context);
    _activityService = ActivityService(jsonRepository);
    _loadActivities();
  }


  // Method called when the page becomes visible
  void onPageVisible() {
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    List<ActivityData> activities = await _activityService.getAllActivities();
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
