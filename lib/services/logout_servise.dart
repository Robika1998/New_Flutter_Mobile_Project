// lib/services/logout_service.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/session.dart';

class LogoutService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<void> logout() async {
    try {
      final uri = Uri.parse('$_baseUrl/MemberAuth/Logout');
      await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (Session.token != null) 'Authorization': 'Bearer ${Session.token}',
        },
      );
    } catch (e) {
      print('⚠️ Logout HTTP error: $e');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Session.token = null;
    Session.decodedUserId = null;
  }
}
