import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'animated_character_widget.dart';

class CharacterDetailWidget extends StatelessWidget {
  const CharacterDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('캐릭터 상세'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 큰 캐릭터 표시
              const SizedBox(
                width: 200,  // 더 큰 사이즈로 조정
                height: 200,
                child: AnimatedCharacterWidget(),  // 기존의 애니메이션 캐릭터 위젯 재사용
              ),

              const SizedBox(height: 24),

              // 캐릭터 정보 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 캐릭터 이름과 설명
                      const Text(
                        '나의 용사',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '레벨 1',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 캐릭터 상세 스탯
                      _buildStatRow('체력', '90'),
                      _buildStatRow('힘', '75'),
                      _buildStatRow('민첩', '82'),
                      _buildStatRow('지능', '68'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}