import 'package:fitnesstracker/repository/json_repository.dart';
import 'package:fitnesstracker/service/running_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/running_plan.dart';
import 'running_plan_page.dart';

class RunningPlansPage extends StatefulWidget {
  @override
  _RunningPlansPageState createState() => _RunningPlansPageState();
}

class _RunningPlansPageState extends State<RunningPlansPage> {
  late RunningPlansService _runningPlansService;
  late Future<List<RunningPlanData>> _runningPlansFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final jsonRepository = Provider.of<JsonRepository>(context);
    _runningPlansService = RunningPlansService(jsonRepository);
    _loadRunningPlans();
  }

  void _loadRunningPlans() {
    _runningPlansFuture = _runningPlansService.getRunningPlans();
  }

  void _navigateToRunningPlan(RunningPlanData plan) {
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
      body: FutureBuilder<List<RunningPlanData>>(
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
          _navigateToRunningPlan(RunningPlanData(name: "", intervals: []));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
