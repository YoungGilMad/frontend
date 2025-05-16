import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  final int? statusCode;
  
  AuthException(this.message, {this.statusCode});
  
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => 'Network error: $message';
}

class AuthRepository {
  final String baseUrl;
  
  AuthRepository({String? baseUrl}) 
    : baseUrl = baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

  // HTTP 요청 공통 처리 메서드
  Future<dynamic> _handleRequest(Future<http.Response> request) async {
    try {
      final response = await request.timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('인터넷 연결을 확인해주세요.');
    } on TimeoutException {
      throw NetworkException('요청 시간이 초과되었습니다. 다시 시도해주세요.');
    } catch (e) {
      throw AuthException('알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // HTTP 응답 처리 메서드
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = utf8.decode(response.bodyBytes);
    
    switch (statusCode) {
      case 200:
      case 201:
        return json.decode(responseBody);
      case 400:
        final error = json.decode(responseBody);
        throw AuthException(error['detail'] ?? '잘못된 요청입니다.', statusCode: statusCode);
      case 401:
        throw AuthException('인증에 실패했습니다. 다시 로그인해주세요.', statusCode: statusCode);
      case 403:
        throw AuthException('접근 권한이 없습니다.', statusCode: statusCode);
      case 404:
        throw AuthException('요청한 리소스를 찾을 수 없습니다.', statusCode: statusCode);
      case 409:
        throw AuthException('이미 존재하는 이메일입니다.', statusCode: statusCode);
      case 500:
      case 502:
      case 503:
        throw AuthException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', statusCode: statusCode);
      default:
        throw AuthException('예상치 못한 오류가 발생했습니다. (상태 코드: $statusCode)', statusCode: statusCode);
    }
  }

  // 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ),
    );

    return {
      'token': response['access_token'],
      'user': UserModel.fromLoginResponse(response),
    };
  }

  // 회원가입
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
      'name': name,
      'phone_number': phoneNumber,
    });

    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ),
    );

    return UserModel.fromRegisterResponse(response);
  }

  // 사용자 정보 조회
  Future<UserModel> getUserInfo(String token) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return UserModel.fromJson(response);
  }

  // 토큰 검증
  Future<bool> validateToken(String token) async {
    try {
      await _handleRequest(
        http.get(
          Uri.parse('$baseUrl/users/me'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return true;
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        return false;
      }
      throw e;
    }
  }

  // 토큰 갱신
  Future<Map<String, dynamic>?> refreshToken(String token) async {
    try {
      final response = await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/users/refresh-token'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return {
        'token': response['access_token'],
        'user': UserModel.fromJson(response['user']),
      };
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        return null;
      }
      throw e;
    }
  }

  // 로그아웃 (서버에 알릴 필요가 있는 경우)
  Future<void> logout(String token) async {
    try {
      await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/users/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      // 서버 로그아웃 실패해도 로컬에서는 로그아웃 처리
    }
  }

  // 사용자 정보 업데이트
  Future<UserModel?> updateUserInfo({
    required String token,
    required int userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final Map<String, dynamic> updateData = {};
    
    if (name != null) updateData['name'] = name;
    if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
    if (profileImageUrl != null) updateData['profile_img'] = profileImageUrl;
    
    if (updateData.isEmpty) return null;
    
    final response = await _handleRequest(
      http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      ),
    );
    
    return UserModel.fromJson(response);
  }

  // 비밀번호 변경
  Future<bool> changePassword({
    required String token,
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final requestBody = jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
    });
    
    try {
      await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/users/$userId/change-password'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: requestBody,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 비밀번호 재설정 요청
  Future<bool> requestPasswordReset(String email) async {
    try {
      await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/users/password-reset'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 비밀번호 재설정 확인
  Future<bool> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/users/password-reset-confirm'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'token': token,
            'new_password': newPassword,
          }),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 이메일 중복 확인
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await _handleRequest(
        http.get(
          Uri.parse('$baseUrl/users/check-email/$email'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return response['available'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // 회원 탈퇴
  Future<bool> deleteAccount({
    required String token,
    required int userId,
    required String password,
  }) async {
    try {
      await _handleRequest(
        http.delete(
          Uri.parse('$baseUrl/users/remove/$userId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'password': password}),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}