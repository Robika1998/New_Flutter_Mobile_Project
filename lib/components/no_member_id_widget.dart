// widgets/no_member_id_widget.dart
import 'package:flutter/material.dart';

class NoMemberIdWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            'No member ID found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text('Please login again', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
