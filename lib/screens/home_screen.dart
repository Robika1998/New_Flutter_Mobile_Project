import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/services/logout_servise.dart';
import '../models/my_task.dart';
import '../services/task_service.dart';
import '../utils/session.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final memberId = Session.decodedUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await LogoutService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body:
          memberId == null
              ? Center(child: Text('No memberId found.'))
              : FutureBuilder<List<MyTask>>(
                future: ApiService.getMyTasks(memberId),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }

                  final tasks = snap.data ?? [];

                  if (tasks.isEmpty) {
                    return Center(child: Text('No tasks available'));
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, i) {
                      final task = tasks[i];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('VIN: ${task.vin}'),
                              Text('Carrier: ${task.carrierName}'),
                              Text('Dealer: ${task.dealerName}'),
                              Text(
                                'Confirmed Dealer: ${task.confirmedDealer ? "Yes" : "No"}',
                              ),
                              Text('Date: ${task.orderDate.substring(0, 10)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
