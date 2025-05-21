import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/services/logout_servise.dart';
import '../services/delete_account_service.dart';
import '../utils/session.dart';
import '../components/no_member_id_widget.dart';
import '../components/task_list.dart';
import '../components/privacy_policy_modal.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<TaskListState> _taskListKey = GlobalKey<TaskListState>();

  @override
  Widget build(BuildContext context) {
    final memberId = Session.decodedUserId;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, memberId),
      body:
          memberId == null
              ? NoMemberIdWidget()
              : TaskList(key: _taskListKey, memberId: memberId),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _taskListKey.currentState?.refresh(),
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String? memberId) {
    return AppBar(
      toolbarHeight: 80,
      title: Row(
        children: [
          Image.asset('assets/logo-dark1.png', height: 100),
          SizedBox(width: 12),

          // Text('MyKeyBox', style: TextStyle(fontSize: 20)),
        ],
      ),

      backgroundColor: Colors.blue[800],
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white, size: 30),
          offset: Offset(0, 50),
          onSelected: (value) async {
            if (value == 'delete_account' && memberId != null) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text(
                        'Do you really want to delete your account?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (confirmed == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(child: CircularProgressIndicator()),
                );
                try {
                  await DeleteAccountService.deleteAccount(memberId);
                  await LogoutService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (_) => false,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            } else if (value == 'privacy_policy') {
              showDialog(
                context: context,
                builder: (_) => const PrivacyPolicyModal(),
              );
            } else if (value == 'logout') {
              await LogoutService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (_) => false,
              );
            }
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
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Log Out', style: TextStyle(color: Colors.red)),
                ),
              ],
        ),
      ],
    );
  }
}
