import 'package:flutter/material.dart';
import '../../data/models/statistics_model.dart';
import '../../data/repositories/statistics_repository.dart';

enum StatisticsLoadingStatus {
  initial,
  loading,
  loaded,
  error,
}

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;
  final String _token;
  final int _userId;
  
  StatisticsLoadingStatus _status = StatisticsLoadingStatus.initial;
  StatisticsModel? _statistics;
  String? _error;
  
  // 현재 선택된 기간 (주간, 월간, 연간)
  String _selectedPeriod = 'week';
  List<ActivityData>? _periodData;
  
  StatisticsProvider({
    required StatisticsRepository repository,
    required String token,
    required int userId,
  }) : _repository = repository,
       _token = token,
       _userId = userId;
  
  // Getters
  StatisticsLoadingStatus get status => _status;
  StatisticsModel? get statistics => _statistics;
  String? get error => _error;
  String get selectedPeriod => _selectedPeriod;
  List<ActivityData>? get periodData => _periodData;
  
  // 종합 통계 데이터 로드
  Future<void> loadStatistics() async {
    _status = StatisticsLoadingStatus.loading;
    _error = null;
    notifyListeners();
    
    try {
      _statistics = await _repository.getUserStatistics(_token, _userId);
      _status = StatisticsLoadingStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = StatisticsLoadingStatus.error;
    }
    
    notifyListeners();
  }
  
  // 특정 기간의 통계 데이터 로드
  Future<void> loadPeriodStatistics(String period) async {
    _selectedPeriod = period;
    notifyListeners();
    
    try {
      _periodData = await _repository.getPeriodStatistics(_token, _userId, period);
    } catch (e) {
      _error = e.toString();
    }
    
    notifyListeners();
  }
  
  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }
}