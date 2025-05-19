// lib/services/task_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/my_task.dart';
import '../utils/session.dart';
import 'token_service.dart';

class ApiService {
  static const _baseUrl = 'http://back.mykeybox.com/api/dealership-module';

  static Future<http.Response> authenticatedRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    var response = await requestFn();

    if (response.statusCode == 401) {
      try {
        await TokenService.refreshToken();
        response = await requestFn();
      } catch (e) {
        print('❌ Token refresh failed: $e');
        rethrow;
      }
    }

    return response;
  }

  static Future<List<MyTask>> getMyTasks(String memberId) async {
    print('📋 Fetching tasks for member: $memberId');
    final uri = Uri.parse('$_baseUrl/Member/GetMyTask?memberId=$memberId');

    final response = await authenticatedRequest(() async {
      return await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Session.token}',
        },
      );
    });

    print('📥 Response status: ${response.statusCode}');
    print('📦 Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        print('🔄 Decoded response: $decoded');

        final tasksList = decoded['tasks'] as List? ?? [];
        print('✅ Successfully loaded ${tasksList.length} tasks');

        return tasksList.map((e) => MyTask.fromJson(e)).toList();
      } catch (e) {
        print('❌ JSON decode error: $e');
        throw Exception('Failed to decode tasks');
      }
    } else {
      throw Exception('Failed to load tasks (${response.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    final uri = Uri.parse(
      'http://back.mykeybox.com/api/dealership-module/Member/GetOrderById/$orderId',
    );

    final response = await authenticatedRequest(() async {
      return await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Session.token}',
        },
      );
    });

    print('🔍 getOrderById Response status: ${response.statusCode}');
    print('🔍 getOrderById Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        print('🔍 Decoded Order Details: $decoded');
        return decoded;
      } catch (e) {
        print('❌ JSON decode error: $e');
        throw Exception('Failed to decode order details');
      }
    } else {
      throw Exception('Failed to load order details (${response.statusCode})');
    }
  }
}
