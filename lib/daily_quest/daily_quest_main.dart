import 'package:flutter/material.dart';

class DailyQuestMainScreen extends StatelessWidget {
  const DailyQuestMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quest'),
      ),
      body: const Center(
        child: Text('Daily Quest Screen'),
      ),
    );
  }
}