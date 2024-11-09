import 'package:fitnesstracker/pages/running_plans_page.dart';
import 'package:flutter/material.dart';
import 'new_activity_page.dart';
import 'previous_activities_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final NewActivityPage activityPage = NewActivityPage();
  final PreviousActivitiesPage previousActivitiesPage =
      PreviousActivitiesPage();
  final RunningPlansPage runningPlansPage = RunningPlansPage();

  late final List<Widget> _pages = [activityPage, previousActivitiesPage, runningPlansPage];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children:
            _pages, // Keeps all pages alive and only shows the selected one
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'New Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Previous Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Plans',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
