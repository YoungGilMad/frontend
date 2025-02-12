import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'character_detail_widget.dart';
import 'animated_character_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroStatusWidget extends StatelessWidget {
  const HeroStatusWidget({super.key});

  @override
  // lib/widgets/home/hero_status_widget.dart의 일부

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 기본 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroInfo(context, authProvider),
                  const SizedBox(height: 8),
                  _buildExperienceBar(context),
                ],
              ),
              const SizedBox(height: 16),
              // 능력치 그리드
              _buildStatsGrid(context),
            ],
          ),
        );
      },
    );
  }

// _buildHeroAvatar 메서드는 제거

  Widget _buildHeroAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CharacterDetailWidget(),
          ),
        );
      },
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            const AnimatedCharacterWidget(),  // 새로 만든 위젯 사용
            // Positioned(
            //   right: 0,
            //   bottom: 0,
            //   // child: Container(
            //   //   padding: const EdgeInsets.all(4),
            //   //   decoration: BoxDecoration(
            //   //     color: Theme.of(context).colorScheme.primary,
            //   //     shape: BoxShape.circle,
            //   //   ),
            //   //   child: const Icon(
            //   //     Icons.edit,
            //   //     size: 16,
            //   //     color: Colors.white,
            //   //   ),
            //   // ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroInfo(BuildContext context, AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authProvider.user?.nickname ?? '용사님',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Lv. ${authProvider.user?.level ?? 1}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.military_tech,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '랭킹 15위',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '경험치',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '8,740 / 10,000 XP',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.874,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final stats = [
      {'icon': Icons.fitness_center, 'name': '힘', 'value': '75'},
      {'icon': Icons.speed, 'name': '민첩', 'value': '82'},
      {'icon': Icons.psychology, 'name': '지능', 'value': '68'},
      {'icon': Icons.favorite, 'name': '체력', 'value': '90'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                stat['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                stat['name'] as String,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                stat['value'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}