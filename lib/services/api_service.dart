// lib/services/api_servise.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/login_type.dart';
import '../utils/session.dart';

class ApiService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<bool> signIn(LoginType creds) async {
    final uri = Uri.parse('$_baseUrl/MemberAuth/SignInMember');
    late final http.Response response;

    try {
      response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(creds.toJson()),
      );
    } catch (e) {
      print('❌ HTTP request error: $e');
      return false;
    }

    if (response.statusCode != 200) {
      print('❌ SignIn failed (${response.statusCode}): ${response.body}');
      return false;
    }

    try {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'] as String;
      final refreshToken = responseData['refreshToken'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('refresh_token', refreshToken);

      Session.token = token;
      Session.refreshToken = refreshToken;

      final claims = JwtDecoder.decode(token);
      Session.decodedUserId = claims['Id']?.toString();
      print('✅ decodedUserId = ${Session.decodedUserId}');

      return true;
    } catch (e) {
      print('❌ Token processing error: $e');
      return false;
    }
  }
}
