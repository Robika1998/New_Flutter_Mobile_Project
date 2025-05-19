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

  bool isAuthorized = false;

  if (Session.token != null && Session.refreshToken != null) {
    if (JwtDecoder.isExpired(Session.token!)) {
      isAuthorized = await TokenService.refreshToken();
      if (!isAuthorized) {
        print('❌ Refresh failed, user must login.');
      }
    } else {
      isAuthorized = true;
      final claims = JwtDecoder.decode(Session.token!);
      Session.decodedUserId = claims['Id']?.toString();
    }
  }

  runApp(MyApp(isAuthorized: isAuthorized));
}

class MyApp extends StatelessWidget {
  final bool isAuthorized;

  const MyApp({required this.isAuthorized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKeyBox',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isAuthorized ? HomeScreen() : LoginScreen(),
    );
  }
}
