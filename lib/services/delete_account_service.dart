import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/session.dart';

class DeleteAccountService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<void> deleteAccount(String id) async {
    var token = Session.token;
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('auth_token');
    }
    if (token == null) throw Exception('No auth token available');

    final url = Uri.parse('$_baseUrl/Member/DeleteProfile/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      // You can parse response.body for a more specific error message
      throw Exception(
        'Failed to delete account (${response.statusCode}): ${response.body}',
      );
    }

    // Clear session & stored tokens
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    Session.token = null;
    Session.refreshToken = null;
    Session.decodedUserId = null;
  }
}
