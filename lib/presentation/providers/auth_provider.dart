import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  Timer? _tokenRefreshTimer;

  // 토큰 만료 시간 설정 (기본 30분)
  final int _tokenExpiryMinutes = 30;

  AuthProvider({
    required AuthRepository authRepository,
    required SharedPreferences prefs,
  })  : _authRepository = authRepository,
        _prefs = prefs {
    _loadSavedToken();
  }

  // Getters
  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SharedPreferences get prefs => _prefs;  // SharedPreferences 접근자

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 저장된 토큰 로드 및 유효성 검증
  Future<void> _loadSavedToken() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // 저장된 토큰과 만료 시간 가져오기
      _token = _prefs.getString('auth_token');
      final tokenExpiryTime = _prefs.getInt('token_expiry_time');
      
      if (_token != null) {
        // 토큰 만료 여부 확인
        if (tokenExpiryTime != null && 
            DateTime.now().millisecondsSinceEpoch < tokenExpiryTime) {
          
          // 토큰 유효성 검증
          final isValid = await _authRepository.validateToken(_token!);
          
          if (isValid) {
            // 사용자 정보 가져오기
            await _fetchUserInfo();
            
            // 토큰 자동 갱신 타이머 설정
            _setupTokenRefreshTimer(tokenExpiryTime);
          } else {
            // 토큰이 유효하지 않은 경우
            await logout();
          }
        } else {
          // 토큰이 만료된 경우
          await logout();
        }
      }
    } catch (e) {
      _error = "자동 로그인 중 오류가 발생했습니다.";
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 사용자 정보 가져오기
  Future<void> _fetchUserInfo() async {
    if (_token == null) return;
    
    try {
      final response = await _authRepository.getUserInfo(_token!);
      _user = response;
    } catch (e) {
      _error = "사용자 정보를 가져오는 중 오류가 발생했습니다.";
    }
  }

  // 토큰 자동 갱신 타이머 설정
  void _setupTokenRefreshTimer(int expiryTime) {
    // 기존 타이머가 있으면 취소
    _tokenRefreshTimer?.cancel();
    
    // 만료 시간까지 남은 시간 계산 (5분 전에 갱신)
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeToRefresh = expiryTime - now - (5 * 60 * 1000); // 5분 전에 갱신
    
    if (timeToRefresh > 0) {
      _tokenRefreshTimer = Timer(Duration(milliseconds: timeToRefresh), () {
        refreshToken();
      });
    } else {
      // 이미 갱신 시간이 지난 경우 즉시 갱신
      refreshToken();
    }
  }

  // 토큰 갱신
  Future<void> refreshToken() async {
    if (_token == null) return;
    
    try {
      final result = await _authRepository.refreshToken(_token!);
      
      if (result != null) {
        _token = result['token'];
        
        // 새 토큰과 만료 시간 저장
        final expiryTime = DateTime.now().millisecondsSinceEpoch + 
                         (_tokenExpiryMinutes * 60 * 1000);
        await _prefs.setString('auth_token', _token!);
        await _prefs.setInt('token_expiry_time', expiryTime);
        
        // 새 타이머 설정
        _setupTokenRefreshTimer(expiryTime);
      } else {
        // 갱신 실패
        await logout();
      }
    } catch (e) {
      await logout();
    }
  }

  // 로그인
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      _token = result['token'];
      _user = result['user'];
      
      // 토큰과 만료 시간 저장
      final expiryTime = DateTime.now().millisecondsSinceEpoch + 
                       (_tokenExpiryMinutes * 60 * 1000);
      await _prefs.setString('auth_token', _token!);
      await _prefs.setInt('token_expiry_time', expiryTime);
      
      // 토큰 자동 갱신 타이머 설정
      _setupTokenRefreshTimer(expiryTime);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 회원가입
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      if (_token != null) {
        // 서버에 로그아웃 요청 (실제 API가 있을 경우)
        await _authRepository.logout(_token!);
      }
    } catch (e) {
      // 로그아웃 실패해도 로컬에서는 로그아웃 처리
    } finally {
      // 토큰 갱신 타이머 취소
      _tokenRefreshTimer?.cancel();
      _tokenRefreshTimer = null;
      
      // 로컬 상태 초기화
      _token = null;
      _user = null;
      
      // 저장된 토큰 및 만료 시간 삭제
      await _prefs.remove('auth_token');
      await _prefs.remove('token_expiry_time');
      
      notifyListeners();
    }
  }

  // 사용자 정보 업데이트
  Future<bool> updateUserInfo({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_token == null || _user == null) return false;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final updatedUser = await _authRepository.updateUserInfo(
        token: _token!,
        userId: _user!.id,
        name: name,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
      
      if (updatedUser != null) {
        _user = updatedUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 비밀번호 변경
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_token == null || _user == null) return false;
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _authRepository.changePassword(
        token: _token!,
        userId: _user!.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 회원 탈퇴
  Future<bool> deleteAccount(String password) async {
    if (_token == null || _user == null) return false;
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final success = await _authRepository.deleteAccount(
        token: _token!,
        userId: _user!.id,
        password: password,
      );
      
      if (success) {
        await logout();
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}