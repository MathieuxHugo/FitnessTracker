import 'package:flutter/material.dart';
import '../model/running_plan.dart';
import '../service/running_plan_service.dart';
import 'running_plan_page.dart';

class RunningPlansPage extends StatefulWidget {
  @override
  _RunningPlansPageState createState() => _RunningPlansPageState();
}

class _RunningPlansPageState extends State<RunningPlansPage> {
  final RunningPlansService _runningPlansService = RunningPlansService();
  late Future<List<RunningPlan>> _runningPlansFuture;

  @override
  void initState() {
    super.initState();
    _loadRunningPlans();
  }

  void _loadRunningPlans() {
    _runningPlansFuture = _runningPlansService.getRunningPlans();
  }

  void _navigateToRunningPlan(RunningPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunningPlanPage(runningPlan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Running Plans"),
      ),
      body: FutureBuilder<List<RunningPlan>>(
        future: _runningPlansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load running plans"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No running plans available"));
          }

          final runningPlans = snapshot.data!;

          return ListView.builder(
            itemCount: runningPlans.length,
            itemBuilder: (context, index) {
              final plan = runningPlans[index];
              return Card(
                child: ListTile(
                  title: Text(plan.name),
                  subtitle: Text("${plan.intervals.length} intervals"),
                  onTap: () => _navigateToRunningPlan(plan),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToRunningPlan(RunningPlan.createPlan(name: "", intervals: []));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
