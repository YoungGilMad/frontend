import 'package:flutter/material.dart';

class HeroQuestMainScreen extends StatelessWidget {
  const HeroQuestMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Quest'),
      ),
      body: const Center(
        child: Text('Hero Quest Screen'),
      ),
    );
  }
}