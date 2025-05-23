import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> rankingData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRankingData();
  }

  Future<void> _fetchRankingData() async {
    try {
      final dio = Dio();
      final baseUrl = dotenv.env['API_BASE_URL'];
      final response = await dio.get('$baseUrl/users/ranking');
      setState(() {
        rankingData = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
    } catch (e) {
      print('랭킹 데이터 가져오기 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: rankingData.length,
        itemBuilder: (context, index) {
          final user = rankingData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text('${index + 1}'),
              ),
              title: Text(user['name']),
              subtitle: Text('Lv. ${user['hero_level']}'),
              trailing: user['profile_img'] != null
                  ? Image.network(
                '${dotenv.env['API_BASE_URL']}/${user['profile_img']}',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.person),
            ),
          );
        },
      ),
    );
  }
}
