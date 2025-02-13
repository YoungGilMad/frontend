import 'package:flutter/material.dart';
import '../../widgets/social/ranking_widget.dart';

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
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text('${index + 1}'),
                    ),
                    title: Text('User ${index + 1}'),
                    trailing: const Text('1000 pt'),
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