// lib/services/token_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/env.dart';
import '../utils/session.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<void> refreshToken() async {
    print('🔄 Attempting token refresh...');
    final prefs = await SharedPreferences.getInstance();
    final refreshToken =
        Session.refreshToken ?? prefs.getString('refresh_token');
    print('🔑 Current refresh token: ${refreshToken?.substring(0, 10)}...');

    if (refreshToken == null) {
      print('❌ No refresh token available');
      throw Exception('No refresh token available');
    }

    final uri = Uri.parse('$_baseUrl/MemberAuth/Refresh');
    print('🌐 Sending refresh request to: $uri');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    print('🔔 Refresh response status: ${resp.statusCode}');
    print('📩 Refresh response body: ${resp.body}');

    if (resp.statusCode != 200) {
      print('⚠️ Clearing tokens due to refresh failure');
      await prefs.remove('refresh_token');
      Session.token = null;
      Session.refreshToken = null;
      Session.decodedUserId = null;
      throw Exception('Refresh failed (${resp.statusCode}) ${resp.body}');
    }

    final data = jsonDecode(resp.body);
    final newToken = data['token'] as String;
    final newRefreshToken = data['refreshToken'] as String;
    print(
      '🆕 New token received. Expiration: ${JwtDecoder.getExpirationDate(newToken)}',
    );

    await prefs.setString('auth_token', newToken);
    await prefs.setString('refresh_token', newRefreshToken);

    Session.token = newToken;
    Session.refreshToken = newRefreshToken;

    try {
      final claims = JwtDecoder.decode(newToken);
      Session.decodedUserId = claims['Id']?.toString();
    } catch (e) {
      print('❌ JWT decode error after refresh: $e');
      Session.decodedUserId = null;
    }
  }
}
