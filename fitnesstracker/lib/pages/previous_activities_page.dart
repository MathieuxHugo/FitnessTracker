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

  Future<bool> _showDeleteConfirmationDialog(ActivityData activity) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: const Text('Are you sure you want to delete this activity? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the activity
                await _activityService.deleteActivity(activity.id);
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed without a choice
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
          return Dismissible(
            key: Key(activity.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart, // Only allow swipe from right to left
            confirmDismiss: (direction) {
              return _showDeleteConfirmationDialog(activity);
            },
            onDismissed: (direction) {
              setState(() {
                _activities.removeAt(index);
              });
            },
            child: ListTile(
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
                ).then((_) {
                  // Refresh the list when returning from detail page
                  _loadActivities();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
