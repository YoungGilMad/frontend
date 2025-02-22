import 'package:flutter/material.dart';
import '../../widgets/social/friend_list_widget.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 친구 검색 바
          SearchBar(
            hintText: '친구 검색',
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onChanged: (query) {
              // TODO: Implement friend search
            },
          ),
          const SizedBox(height: 16),
          // 친구 목록
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person),
                    ),
                    title: Text('Friend ${index + 1}'),
                    subtitle: const Text('Level 10'),
                    trailing: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // TODO: Implement wake up friend
                      },
                    ),
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