import 'package:flutter/material.dart';
import 'package:new_mykeybox_flutter/services/logout_servise.dart';
import '../screens/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/logo-dark1.png', height: 80),
          SizedBox(width: 12),
        ],
      ),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
