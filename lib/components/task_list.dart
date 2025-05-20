// lib/components/task_list.dart
import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/components/empty_state_widget.dart';
import '../models/my_task.dart';
import '../services/task_service.dart';
import 'task_card.dart';

class TaskList extends StatefulWidget {
  final String memberId;
  const TaskList({Key? key, required this.memberId}) : super(key: key);

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  late Future<List<MyTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    _tasksFuture = ApiService.getMyTasks(widget.memberId);
  }

  Future<void> refresh() async {
    _loadTasks();
    setState(() {});
    await _tasksFuture;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder<List<MyTask>>(
        future: _tasksFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Failed to load tasks',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          final tasks = snap.data!;
          if (tasks.isEmpty) {
            return EmptyStateWidget();
          }
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (_, i) => TaskCard(task: tasks[i]),
          );
        },
      ),
    );
  }
}
