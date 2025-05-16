import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:new_mykeybox_flutter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/token_service.dart';
import 'utils/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  Session.token = prefs.getString('auth_token');
  Session.refreshToken = prefs.getString('refresh_token');

  if (Session.token != null) {
    try {
      final claims = JwtDecoder.decode(Session.token!);
      Session.decodedUserId = claims['Id']?.toString();
      print('✅ decodedUserId = ${Session.decodedUserId}');

      if (JwtDecoder.isExpired(Session.token!)) {
        try {
          await TokenService.refreshToken();
        } catch (e) {
          print('❌ Initial token refresh failed: $e');
          await prefs.remove('auth_token');
          await prefs.remove('refresh_token');
          Session.token = null;
          Session.refreshToken = null;
          Session.decodedUserId = null;
        }
      }
    } catch (e) {
      print('❌ JWT decode error: $e');
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      Session.token = null;
      Session.refreshToken = null;
      Session.decodedUserId = null;
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKeyBox',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Session.token != null ? HomeScreen() : LoginScreen(),
    );
  }
}
