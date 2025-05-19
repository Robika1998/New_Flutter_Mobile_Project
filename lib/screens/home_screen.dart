// import 'package:flutter/material.dart';
// import 'package:new_mykeybox_flutter/services/logout_servise.dart';
// import '../models/my_task.dart';
// import '../services/task_service.dart';
// import '../utils/session.dart';
// import 'login_screen.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final memberId = Session.decodedUserId;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _buildAppBar(context),
//       body:
//           memberId == null
//               ? _buildNoMemberIdWidget()
//               : _buildTaskList(context, memberId),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (_, __, ___) => HomeScreen(),
//               transitionDuration: Duration.zero,
//             ),
//           );
//         },
//         backgroundColor: Colors.blue[800],
//         child: Icon(Icons.refresh, color: Colors.white),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       title: Row(
//         children: [
//           Image.asset('assets/logo-dark1.png', height: 80),
//           SizedBox(width: 12),
//         ],
//       ),
//       centerTitle: false,
//       elevation: 0,
//       backgroundColor: Colors.blue[800],
//       actions: [
//         PopupMenuButton<String>(
//           icon: Icon(Icons.menu, color: Colors.white),
//           onSelected: (value) async {
//             switch (value) {
//               case 'delete_account':
//                 break;
//               case 'privacy_policy':
//                 break;
//               case 'logout':
//                 await LogoutService.logout();
//                 Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (_) => LoginScreen()),
//                   (route) => false,
//                 );
//                 break;
//             }
//           },
//           itemBuilder:
//               (BuildContext context) => <PopupMenuEntry<String>>[
//                 PopupMenuItem<String>(
//                   value: 'delete_account',
//                   child: Text('Delete Account'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'privacy_policy',
//                   child: Text('Privacy & Policy'),
//                 ),
//                 PopupMenuItem<String>(value: 'logout', child: Text('Log Out')),
//               ],
//         ),
//       ],
//     );
//   }

//   Widget _buildNoMemberIdWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
//           SizedBox(height: 16),
//           Text(
//             'No member ID found',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text('Please login again', style: TextStyle(color: Colors.grey[600])),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskList(BuildContext context, String memberId) {
//     return FutureBuilder<List<MyTask>>(
//       future: ApiService.getMyTasks(memberId),
//       builder: (ctx, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return _buildLoadingIndicator();
//         }

//         if (snap.hasError) {
//           return _buildErrorWidget(snap.error.toString());
//         }

//         final tasks = snap.data ?? [];

//         if (tasks.isEmpty) {
//           return _buildEmptyStateWidget();
//         }

//         return RefreshIndicator(
//           onRefresh: () async {
//             Navigator.pushReplacement(
//               context,
//               PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => HomeScreen(),
//                 transitionDuration: Duration.zero,
//               ),
//             );
//           },
//           child: ListView.builder(
//             padding: EdgeInsets.all(8),
//             itemCount: tasks.length,
//             itemBuilder: (_, i) => _buildTaskCard(context, tasks[i]),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Image.asset('assets/logo-dark1.png', width: 80, height: 80),
//               SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
//                   strokeWidth: 3,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.warning_amber_rounded,
//               size: 48,
//               color: Colors.orange[700],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               error.length > 100 ? '${error.substring(0, 100)}...' : error,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add retry functionality
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[800],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: Text('Try Again', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyStateWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.assignment_outlined, size: 64, color: Colors.blue[300]),
//           SizedBox(height: 16),
//           Text(
//             'No tasks available',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'When you have tasks, they will appear here',
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCard(BuildContext context, MyTask task) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _showTaskDetails(context, task),
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
//               _buildDetailRow(Icons.local_shipping, task.carrierName),
//               _buildDetailRow(Icons.store, task.dealerName),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
//                   SizedBox(width: 8),
//                   Text(
//                     task.orderDate.substring(0, 10),
//                     style: TextStyle(color: Colors.grey[700], fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(color: Colors.grey[800], fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showTaskDetails(BuildContext context, MyTask task) async {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder:
//           (_) => DraggableScrollableSheet(
//             initialChildSize: 0.75,
//             maxChildSize: 0.95,
//             minChildSize: 0.5,
//             expand: false,
//             builder:
//                 (context, scrollController) => Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(24),
//                     ),
//                   ),
//                   child: FutureBuilder<Map<String, dynamic>>(
//                     future: ApiService.getOrderById(task.id.toString()),
//                     builder: (context, snap) {
//                       if (snap.connectionState == ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.blue[800],
//                           ),
//                         );
//                       }

//                       if (snap.hasError) {
//                         return Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.error,
//                                 size: 60,
//                                 color: Colors.red[400],
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'Failed to load details',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Please try again later',
//                                 style: TextStyle(color: Colors.grey[600]),
//                               ),
//                               SizedBox(height: 20),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.of(context).pop(),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[800],
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Close',
//                                   style: TextStyle(
//                                     color: const Color.fromARGB(255, 235, 5, 5),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       final order = snap.data ?? {};
//                       return SingleChildScrollView(
//                         controller: scrollController,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(
//                               child: Container(
//                                 width: 50,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 margin: EdgeInsets.only(bottom: 16),
//                               ),
//                             ),
//                             Text(
//                               'Task Details',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue[900],
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             _buildDetailCard(
//                               title: 'Vehicle Information',
//                               items: [
//                                 _buildDetailItem('VIN', order['vin']),
//                                 _buildDetailItem('Vehicle', order['vehicle']),
//                                 _buildDetailItem(
//                                   'Order Status',
//                                   order['orderStatus'],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             _buildDetailCard(
//                               title: 'Information',
//                               items: [
//                                 _buildDetailItem(
//                                   'Carrier',
//                                   order['sharedCarrier'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Dealer',
//                                   order['sharedDealershipOffice'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Dealer Code',
//                                   order['dealerCode'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Guest User Code',
//                                   order['guestUserCode'],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             _buildDetailCard(
//                               title: 'Timing',
//                               items: [
//                                 _buildDetailItem(
//                                   'Order Date',
//                                   order['orderDate'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Data Updated',
//                                   order['dataUpdated'],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             _buildDetailCard(
//                               title: 'Additional Information',
//                               items: [
//                                 _buildDetailItem(
//                                   'Pickup Info',
//                                   order['pickupInformation'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Delivery Info',
//                                   order['deliveryInformation'],
//                                 ),
//                                 _buildDetailItem(
//                                   'Other Info',
//                                   order['additionalInformation'],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             _buildDetailCard(
//                               title: 'Confirmation',
//                               items: [
//                                 _buildDetailItem(
//                                   'Confirmed by Dealer',
//                                   order['confirmedByDealership'] == true
//                                       ? 'Yes'
//                                       : 'No',
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 24),
//                             Center(),
//                             SizedBox(height: 12),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           ),
//     );
//   }

//   Widget _buildDetailCard({
//     required String title,
//     required List<Widget> items,
//   }) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey[200]!, width: 1),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blue[800],
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 8),
//             Divider(height: 1, color: Colors.grey[200]),
//             SizedBox(height: 8),
//             ...items,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String? value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(
//             value ?? 'N/A',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[800],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }

// home_screen.dart
import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/components/no_member_id_widget.dart';
import 'package:new_mykeybox_flutter/components/task_list.dart';
import 'package:new_mykeybox_flutter/services/logout_servise.dart';
import '../utils/session.dart';
import '../components/no_member_id_widget.dart';
import '../components/task_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final memberId = Session.decodedUserId;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body:
          memberId == null ? NoMemberIdWidget() : TaskList(memberId: memberId),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        },
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/logo-dark1.png', height: 80),
          SizedBox(width: 12),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.blue[800],
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white),
          onSelected: (value) async {
            if (value == 'logout') {
              await LogoutService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            }
            // other cases...
          },
          itemBuilder:
              (_) => [
                PopupMenuItem(
                  value: 'delete_account',
                  child: Text('Delete Account'),
                ),
                PopupMenuItem(
                  value: 'privacy_policy',
                  child: Text('Privacy & Policy'),
                ),
                PopupMenuItem(value: 'logout', child: Text('Log Out')),
              ],
        ),
      ],
    );
  }
}
