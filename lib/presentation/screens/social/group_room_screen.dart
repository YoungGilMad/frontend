import 'package:flutter/material.dart';
import '../../widgets/social/group_list_widget.dart';
import '../../../data/models/group_item.dart';


class RoomWidget extends StatelessWidget {
  final GroupItem group;

  const RoomWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터
    final int completedQuests = 4;
    final int totalQuests = 5;
    final String timeElapsed = "00:00:00";
    final List<Map<String, dynamic>> dummyData = [
      {'quest': 3, 'total': 5, 'time': "00:00:00"},
      {'quest': 3, 'total': 5, 'time': "00:00:00"},
      {'quest': 3, 'total': 5, 'time': "00:00:00"},
      {'quest': 3, 'total': 5, 'time': "00:00:00"},
      {'quest': 4, 'total': 5, 'time': "00:01:00"},
      {'quest': 2, 'total': 5, 'time': "00:02:00"},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  "나의 진행",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "퀘스트 $completedQuests/$totalQuests",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "시간 $timeElapsed",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: dummyData.length,
                itemBuilder: (context, index) {
                  final data = dummyData[index];
                  return Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text("퀘스트 ${data['quest']}/${data['total']}",
                          style: const TextStyle(fontSize: 14)),
                      Text("시간 ${data['time']}",
                          style: const TextStyle(fontSize: 14)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
