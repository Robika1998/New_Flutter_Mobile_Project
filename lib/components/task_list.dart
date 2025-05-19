// widgets/task_list.dart
import 'package:flutter/material.dart';
import '../models/my_task.dart';
import '../services/task_service.dart';
import 'loading_indicator.dart';
import 'error_display.dart';
import 'empty_state_widget.dart';
import 'task_card.dart';

class TaskList extends StatelessWidget {
  final String memberId;
  const TaskList({required this.memberId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MyTask>>(
      future: ApiService.getMyTasks(memberId),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }
        if (snap.hasError) {
          return ErrorDisplay(error: snap.error.toString());
        }
        final tasks = snap.data ?? [];
        if (tasks.isEmpty) {
          return EmptyStateWidget();
        }
        return RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TaskList(memberId: memberId),
                transitionDuration: Duration.zero,
              ),
            );
          },
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (_, i) => TaskCard(task: tasks[i]),
          ),
        );
      },
    );
  }
}
