import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/home/hero_status_widget.dart';
import '../../widgets/home/progress_chart_widget.dart';
import '../../widgets/home/action_buttons_widget.dart';
import '../../widgets/home/calender_widget.dart';
import '../quest/daily_quest_screen.dart';
import '../quest/hero_quest_screen.dart';
import '../store/store_screen.dart';
import '../../widgets/home/animated_character_widget.dart';  // 경로를 확인해주세요


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 프로필 및 메뉴 영역
                    _buildHeader(context, authProvider),

                    _buildCharacterSection(),

                    // 캐릭터 영역
                    const HeroStatusWidget(),
                    
                    // 진행 상태 영역
                    // _buildProgressSection(context),
                    
                    // 통계 그래프
                    const ProgressChartWidget(),
                    
                    // 활동 요약
                    _buildActivitySummary(context),
                    
                    // 하단 버튼들
                    // const ActionButtonsWidget(),
                    const CalendarWidget(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 정보
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: authProvider.user?.profileImageUrl != null
                    ? NetworkImage(authProvider.user!.profileImageUrl!)
                    : null,
                child: authProvider.user?.profileImageUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.user?.nickname ?? 'GD',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          // 메뉴 버튼들
          Column(
            children: [
              _buildIconButton(
                context,
                Image.asset(
                  'assets/icons/superhero.png',
                  width: 25,      // 더 큰 크기
                  height: 25,
                  fit: BoxFit.contain,  // 이미지가 지정된 영역에 맞게 조정됨
                ),
                const HeroQuestScreen(),
              ),
              _buildIconButton(
                context,
                Image.asset(
                  'assets/icons/checklist.png',
                  width: 25,      // 더 큰 크기
                  height: 25,
                  fit: BoxFit.contain,  // 이미지가 지정된 영역에 맞게 조정됨
                ),
                const DailyQuestScreen(),
              ),
              _buildIconButton(
                context,
                Image.asset(
                  'assets/icons/store.png',
                  width: 25,      // 더 큰 크기
                  height: 25,
                  fit: BoxFit.contain,  // 이미지가 지정된 영역에 맞게 조정됨
                ),
                const StoreScreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 200,
      child: const Center(
        child: AnimatedCharacterWidget(),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, Widget icon, Widget screen) {
    return IconButton(
      icon: icon,  // IconData 대신 Widget을 받도록 수정
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  // Widget _buildProgressSection(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 24.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '궁극의 경지',
  //           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //         ),
  //         const SizedBox(height: 8),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: LinearProgressIndicator(
  //             value: 0.7,
  //             minHeight: 8,
  //             backgroundColor: Colors.grey[200],
  //             valueColor: AlwaysStoppedAnimation<Color>(
  //               Theme.of(context).primaryColor,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActivitySummary(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 활동',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildActivityItem(context, '완료한 퀘스트', '3개'),
          _buildActivityItem(context, '획득한 경험치', '150 XP'),
          _buildActivityItem(context, '달성한 목표', '2/5'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}