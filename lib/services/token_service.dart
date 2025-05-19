// lib/services/token_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/env.dart';
import '../utils/session.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<bool> refreshToken() async {
    print('🔄 Attempting token refresh...');
    final prefs = await SharedPreferences.getInstance();

    final accessToken = Session.token ?? prefs.getString('auth_token');
    final refreshToken =
        Session.refreshToken ?? prefs.getString('refresh_token');

    print('🔑 Current access token: ${accessToken?.substring(0, 10)}...');
    print('🔑 Current refresh token: ${refreshToken?.substring(0, 10)}...');

    if (accessToken == null || refreshToken == null) {
      print('❌ No tokens available');
      await clearTokens();
      return false;
    }

    final uri = Uri.parse('$_baseUrl/MemberAuth/Refresh');
    print('🌐 Sending refresh request to: $uri');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
    );

    print('🔔 Refresh response status: ${resp.statusCode}');
    print('📩 Refresh response body: ${resp.body}');

    if (resp.statusCode != 200) {
      print('⚠️ Refresh failed: Clearing tokens');
      await clearTokens();
      return false;
    }

    final data = jsonDecode(resp.body);
    final newToken = data['token'] as String?;
    final newRefreshToken = data['refreshToken'] as String?;

    if (newToken == null || newRefreshToken == null) {
      print('❌ Invalid tokens received from server');
      await clearTokens();
      return false;
    }

    await prefs.setString('auth_token', newToken);
    await prefs.setString('refresh_token', newRefreshToken);

    Session.token = newToken;
    Session.refreshToken = newRefreshToken;

    try {
      final claims = JwtDecoder.decode(newToken);
      Session.decodedUserId = claims['Id']?.toString();
      print(
        '🆕 Token refreshed successfully, userId: ${Session.decodedUserId}',
      );
      return true;
    } catch (e) {
      print('❌ JWT decode error after refresh: $e');
      await clearTokens();
      return false;
    }
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    Session.clear();
  }
}
