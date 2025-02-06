import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthRepository {
  final String baseUrl;
  
  AuthRepository({String? baseUrl}) 
    : baseUrl = baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

  // 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['access_token'],
        'user': UserModel.fromLoginResponse(data),
      };
    } else {
      final error = jsonDecode(response.body);
      throw AuthException(error['detail'] ?? 'Login failed');
    }
  }

  // 회원가입
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromRegisterResponse(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw AuthException(error['detail'] ?? 'Registration failed');
    }
  }

  // 로그아웃 (토큰 삭제는 로컬에서 처리)
  Future<void> logout() async {
    // 서버 측 로그아웃이 필요한 경우 여기에 구현
  }

  // 토큰 검증
  Future<bool> validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
  
  @override
  String toString() => message;
}