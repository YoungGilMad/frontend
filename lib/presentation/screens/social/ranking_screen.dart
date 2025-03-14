import 'package:flutter/material.dart';
import '../../widgets/social/ranking_list_widget.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 0,  // 실제 데이터 길이로 변경 필요
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text(''),  // 실제 순위 데이터 필요
                    ),
                    title: Text(''),  // 실제 사용자 이름 데이터 필요
                    trailing: const Text(''),  // 실제 포인트 데이터 필요
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}