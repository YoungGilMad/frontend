// character_detail_screen.dart
import 'package:flutter/material.dart';

class CharacterDetailWidget extends StatelessWidget {
  const CharacterDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('캐릭터 상세'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 여기에 캐릭터 상세 정보를 추가하세요
          ],
        ),
      ),
    );
  }
}