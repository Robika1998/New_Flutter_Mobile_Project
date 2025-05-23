// // widgets/task_card.dart
// import 'package:flutter/material.dart';
// import 'package:new_mykeybox_flutter/components/task_detail_bottom_sheet.dart';
// import '../models/my_task.dart';
// import 'detail_row.dart';
// import 'detail_row.dart';

// class TaskCard extends StatelessWidget {
//   final MyTask task;
//   const TaskCard({required this.task});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => TaskDetailBottomSheet.show(context, task),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     task.vin,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color:
//                           task.confirmedDealer
//                               ? Colors.green[50]
//                               : Colors.orange[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color:
//                             task.confirmedDealer
//                                 ? Colors.green[100]!
//                                 : Colors.orange[100]!,
//                         width: 1,
//                       ),
//                     ),
//                     child: Text(
//                       task.confirmedDealer ? 'Confirmed' : 'Not Confirmed',
//                       style: TextStyle(
//                         color:
//                             task.confirmedDealer
//                                 ? Colors.green[800]
//                                 : Colors.orange[800],
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               DetailRow(icon: Icons.local_shipping, text: task.carrierName),
//               DetailRow(icon: Icons.store, text: task.dealerName),
//               SizedBox(height: 8),
//               DetailRow(
//                 icon: Icons.calendar_today,
//                 text: task.orderDate.substring(0, 10),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/components/task_detail_bottom_sheet.dart';
import '../models/my_task.dart';

class TaskCard extends StatelessWidget {
  final MyTask task;
  const TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => TaskDetailBottomSheet.show(context, task),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.vin,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[700],
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      task.confirmedDealer ? 'Confirmed' : 'Not Confirmed',
                      style: TextStyle(
                        color:
                            task.confirmedDealer
                                ? Colors.green[700]
                                : Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor:
                        task.confirmedDealer
                            ? Colors.green[50]
                            : Colors.orange[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            task.confirmedDealer
                                ? Colors.green.shade200
                                : Colors.orange.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      task.carrierName,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.store, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      task.dealerName,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    task.orderDate.substring(0, 10),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
