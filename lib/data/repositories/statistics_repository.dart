import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/models/statistics_model.dart';

class StatisticsRepository {
  final String baseUrl;
  
  StatisticsRepository({String? baseUrl}) 
    : baseUrl = baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

  // 사용자의 종합 통계 데이터 조회
  Future<StatisticsModel> getUserStatistics(String token, int userId) async {
    final url = Uri.parse('$baseUrl/hero/statistics/$userId');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StatisticsModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw StatisticsException(error['detail'] ?? '통계 데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      if (e is StatisticsException) rethrow;
      throw StatisticsException('통계 데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 특정 기간(주간, 월간, 연간)의 통계 데이터 조회
  Future<List<ActivityData>> getPeriodStatistics(String token, int userId, String period) async {
    final url = Uri.parse('$baseUrl/hero/statistics/$userId/period?type=$period');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => ActivityData.fromJson(item)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw StatisticsException(error['detail'] ?? '통계 데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      if (e is StatisticsException) rethrow;
      throw StatisticsException('통계 데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 태그별 통계 데이터 조회
  Future<List<TagStatistic>> getTagStatistics(String token, int userId) async {
    final url = Uri.parse('$baseUrl/hero/statistics/$userId/tags');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => TagStatistic.fromJson(item)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw StatisticsException(error['detail'] ?? '태그 통계 데이터를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      if (e is StatisticsException) rethrow;
      throw StatisticsException('태그 통계 데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}

class StatisticsException implements Exception {
  final String message;
  
  StatisticsException(this.message);
  
  @override
  String toString() => message;
}