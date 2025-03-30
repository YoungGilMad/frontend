import 'package:flutter/material.dart';
import 'group_widget.dart';

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
