// lib/screens/widgets/task_detail_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../models/my_task.dart';
import '../services/task_service.dart';

class TaskDetailBottomSheet {
  static void show(BuildContext context, MyTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            expand: false,
            builder:
                (ctx, scrollController) => TaskDetailContent(
                  task: task,
                  scrollController: scrollController,
                ),
          ),
    );
  }
}

class TaskDetailContent extends StatelessWidget {
  final MyTask task;
  final ScrollController scrollController;

  const TaskDetailContent({
    Key? key,
    required this.task,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getOrderById(task.id.toString()),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue[800]),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Failed to load details',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          final order = snap.data!;
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                  ),
                ),

                // Title
                Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 20),

                _DetailCard(
                  title: 'Vehicle Information',
                  items: [
                    _buildDetailItem('VIN', order['vin']),
                    _buildDetailItem('Vehicle', order['vehicle']),
                    _buildDetailItem('Order Status', order['orderStatus']),
                  ],
                ),
                SizedBox(height: 12),

                _DetailCard(
                  title: 'Information',
                  items: [
                    _buildDetailItem('Carrier', order['sharedCarrier']),
                    _buildDetailItem('Dealer', order['sharedDealershipOffice']),
                    _buildDetailItem('Dealer Code', order['dealerCode']),
                    _buildDetailItem('Guest User Code', order['guestUserCode']),
                  ],
                ),
                SizedBox(height: 12),

                _DetailCard(
                  title: 'Timing',
                  items: [
                    _buildDetailItem('Order Date', order['orderDate']),
                    _buildDetailItem('Data Updated', order['dataUpdated']),
                  ],
                ),
                SizedBox(height: 12),

                _DetailCard(
                  title: 'Additional Information',
                  items: [
                    _buildDetailItem('Pickup Info', order['pickupInformation']),
                    _buildDetailItem(
                      'Delivery Info',
                      order['deliveryInformation'],
                    ),
                    _buildDetailItem(
                      'Other Info',
                      order['additionalInformation'],
                    ),
                  ],
                ),
                SizedBox(height: 12),

                _DetailCard(
                  title: 'Confirmation',
                  items: [
                    _buildDetailItem(
                      'Confirmed by Dealer',
                      order['confirmedByDealership'] == true ? 'Yes' : 'No',
                    ),
                  ],
                ),

                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _DetailCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 8),
            ...items,
          ],
        ),
      ),
    );
  }
}
