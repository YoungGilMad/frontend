import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/data/models/quest_item_model.dart';

class DailyQuestProvider extends ChangeNotifier {
  final int userId;
  final String authToken;

  final String apiBaseUrl = "${dotenv.env['API_BASE_URL']!}/quest";

  List<QuestItemModel> _quests = [];
  List<QuestItemModel> get quests => _quests;

  DailyQuestProvider({
    required this.userId,
    required this.authToken,
  }) {
    fetchQuests();
  }

  Future<void> fetchQuests() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/list/$userId'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _quests = data.map((json) => QuestItemModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("퀘스트 불러오기 오류: $e");
    }
  }

  Future<void> addQuest(QuestItemModel quest) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/self-gen/$userId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": quest.title,
          "description": quest.description,
          "tag": quest.tag,
          "complete_time": quest.completeTime.inSeconds,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newQuest = QuestItemModel.fromJson(data['quest']);
        _quests.insert(0, newQuest);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("퀘스트 생성 오류: $e");
    }
  }

  Future<void> completeQuest(QuestItemModel quest) async {
    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/self-clear/${quest.id}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        _quests.removeWhere((q) => q.id == quest.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("퀘스트 완료 처리 오류: $e");
    }
  }

  Future<void> deleteQuest(QuestItemModel quest) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/remove/${quest.id}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        _quests.removeWhere((q) => q.id == quest.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("퀘스트 삭제 오류: $e");
    }
  }
}