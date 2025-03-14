import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // 수정된 import 구문
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

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
  SharedPreferences get prefs => _prefs;  // SharedPreferences 접근자 추가

  // 저장된 토큰 로드
  Future<void> _loadSavedToken() async {
    _token = _prefs.getString('auth_token');
    if (_token != null) {
      final isValid = await _authRepository.validateToken(_token!);
      if (!isValid) {
        await logout();
      }
    }
    notifyListeners();
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
      
      // 토큰 저장
      await _prefs.setString('auth_token', _token!);
      
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
      await _authRepository.logout();
    } finally {
      _token = null;
      _user = null;
      await _prefs.remove('auth_token');
      notifyListeners();
    }
  }

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }
}