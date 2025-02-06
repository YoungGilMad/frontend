import 'package:flutter/material.dart';
import '../../data/models/store_item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StoreProvider extends ChangeNotifier {
  final String baseUrl;
  List<StoreItemModel> _items = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '아바타';

  StoreProvider({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

  // Getters
  List<StoreItemModel> get items => _items
      .where((item) => _getCategoryFromType(item.itemType) == _selectedCategory)
      .toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  // 카테고리 변경
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // 아이템 타입을 카테고리로 변환
  String _getCategoryFromType(String itemType) {
    switch (itemType) {
      case 'avatar':
        return '아바타';
      case 'background':
        return '배경';
      case 'effect':
        return '효과';
      default:
        return '기타';
    }
  }

  // 상점 아이템 로드
  Future<void> loadItems() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: API 엔드포인트 구현 후 실제 데이터 로드로 대체
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      _items = [
        StoreItemModel(
          id: '1',
          name: '기본 아바타',
          price: 100,
          itemType: 'avatar',
          description: '기본적인 영웅 아바타입니다.',
        ),
        // 더미 데이터...
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '아이템을 불러오는데 실패했습니다.';
      _isLoading = false;
      notifyListeners();
    }
  }

  // 아이템 구매
  Future<bool> purchaseItem(String userId, String itemId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/item/avatar-buy/$userId/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // 구매 성공 시 아이템 상태 업데이트
        _items = _items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(isOwned: true);
          }
          return item;
        }).toList();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['detail'] ?? '구매에 실패했습니다.');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 아이템 착용
  Future<bool> equipItem(String userId, String itemId, String itemType) async {
    try {
      _isLoading = true;
      notifyListeners();

      final endpoint = itemType == 'avatar' 
          ? 'avatar-wear' 
          : 'background-wear';

      final response = await http.post(
        Uri.parse('$baseUrl/item/$endpoint/$userId/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // 착용 성공 시 아이템 상태 업데이트
        _items = _items.map((item) {
          if (item.itemType == itemType) {
            // 같은 타입의 다른 아이템은 착용 해제
            return item.copyWith(isEquipped: item.id == itemId);
          }
          return item;
        }).toList();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['detail'] ?? '착용에 실패했습니다.');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }
}