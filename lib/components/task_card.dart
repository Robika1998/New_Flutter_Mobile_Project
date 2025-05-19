// widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/components/task_detail_bottom_sheet.dart';
import '../models/my_task.dart';
import 'detail_row.dart';
import 'detail_row.dart';

class TaskCard extends StatelessWidget {
  final MyTask task;
  const TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => TaskDetailBottomSheet.show(context, task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.vin,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          task.confirmedDealer
                              ? Colors.green[50]
                              : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            task.confirmedDealer
                                ? Colors.green[100]!
                                : Colors.orange[100]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      task.confirmedDealer ? 'Confirmed' : 'Not Confirmed',
                      style: TextStyle(
                        color:
                            task.confirmedDealer
                                ? Colors.green[800]
                                : Colors.orange[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DetailRow(icon: Icons.local_shipping, text: task.carrierName),
              DetailRow(icon: Icons.store, text: task.dealerName),
              SizedBox(height: 8),
              DetailRow(
                icon: Icons.calendar_today,
                text: task.orderDate.substring(0, 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
