import 'package:flutter/material.dart';
import '../../../data/models/group_item.dart';

class RoomWidget extends StatelessWidget {
  final GroupItem group;

  const RoomWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(child: Text('${group.name} 방에 입장했습니다!')),
    );
  }
}
