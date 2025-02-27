import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/statistics_model.dart';
import '../../providers/statistics_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_bar_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // 화면이 처음 로드될 때 통계 데이터 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        context.read<StatisticsProvider>().loadStatistics();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsProvider>(
      builder: (context, statisticsProvider, child) {
        return Scaffold(
          appBar: AppBarWidget(
            title: '통계',
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '요약'),
                Tab(text: '캘린더'),
                Tab(text: '태그'),
                Tab(text: '주간'),
              ],
              isScrollable: false,
            ),
          ),
          body: statisticsProvider.status == StatisticsLoadingStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : statisticsProvider.error != null
                  ? _buildErrorState(context, statisticsProvider.error!)
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSummaryTab(statisticsProvider),
                        _buildCalendarTab(statisticsProvider),
                        _buildTagsTab(statisticsProvider),
                        _buildWeeklyTab(statisticsProvider),
                      ],
                    ),
        );
      },
    );
  }

  // 요약 탭을 StatisticsProvider의 데이터로 업데이트
  Widget _buildSummaryTab(StatisticsProvider provider) {
    final statistics = provider.statistics;
    if (statistics == null) {
      return const Center(child: Text('데이터가 없습니다'));
    }

    final summary = statistics.summary;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            title: '총 활동 통계',
            child: Column(
              children: [
                _buildStatItem('총 완료 퀘스트', '${summary.completedQuests}개'),
                _buildStatItem('획득한 경험치', '${summary.totalXp} XP'),
                _buildStatItem('현재 레벨', 'Lv. ${Provider.of<AuthProvider>(context).user?.level ?? 1}'),
                _buildStatItem('평균 일일 활동', '${summary.avgDailyActivity}시간'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: '성과 달성',
            child: Column(
              children: [
                _buildAchievementItem(
                  '연속 달성',
                  '${summary.streakDays}일',
                  Icons.local_fire_department,
                  Colors.orange,
                  summary.streakDays / 10,  // 예: 10일 기준
                ),
                _buildAchievementItem(
                  '월간 목표',
                  '${summary.monthlyGoalPercentage}%',
                  Icons.star,
                  Colors.amber,
                  summary.monthlyGoalPercentage / 100,
                ),
                _buildAchievementItem(
                  '레벨업 진행',
                  '${summary.levelProgressPercentage}%',
                  Icons.trending_up,
                  Colors.green,
                  summary.levelProgressPercentage / 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            '데이터를 불러오는데 실패했습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<StatisticsProvider>().loadStatistics();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  // 캘린더 탭을 StatisticsProvider의 데이터로 업데이트
  Widget _buildCalendarTab(StatisticsProvider provider) {
    final statistics = provider.statistics;
    if (statistics == null || statistics.calendar.isEmpty) {
      return const Center(child: Text('캘린더 데이터가 없습니다'));
    }

    // 캘린더 아이템을 날짜별로 정렬하고 그리드로 표시
    final calendarItems = statistics.calendar;
    final Map<int, CalendarItem> dayMap = {};
    
    for (var item in calendarItems) {
      final day = int.tryParse(item.date.split('-').last) ?? 0;
      dayMap[day] = item;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 31, // 한 달을 기준으로 31일
      itemBuilder: (context, index) {
        final day = index + 1;
        final calendarItem = dayMap[day];
        final activityLevel = calendarItem?.activityLevel ?? 0;
        
        return _buildCalendarDay(day, activityLevel);
      },
    );
  }
  
  // 태그 탭을 StatisticsProvider의 데이터로 업데이트
  Widget _buildTagsTab(StatisticsProvider provider) {
    final statistics = provider.statistics;
    if (statistics == null || statistics.tags.isEmpty) {
      return const Center(child: Text('태그 데이터가 없습니다'));
    }

    final tags = statistics.tags;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                sections: tags.map((tag) => PieChartSectionData(
                  value: tag.percentage.toDouble(),
                  title: '${tag.percentage}%',
                  color: _getTagColor(tag.name),
                  radius: 50,
                )).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                return _buildTagItem(
                  tag.name,
                  '${tag.count}회',
                  _getTagColor(tag.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // 주간 활동 탭을 StatisticsProvider의 데이터로 업데이트
  Widget _buildWeeklyTab(StatisticsProvider provider) {
    final statistics = provider.statistics;
    if (statistics == null || statistics.weekly.isEmpty) {
      return const Center(child: Text('주간 활동 데이터가 없습니다'));
    }

    final weeklyData = statistics.weekly;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                barGroups: _getBarData(weeklyData),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= weeklyData.length) {
                          return const Text('');
                        }
                        final index = value.toInt();
                        final day = weeklyData[index].date.split(' ').last;
                        return Text(
                          day,
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildWeeklySummaryCard(weeklyData),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String label,
    String value,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int day, int activityLevel) {
    final colors = [
      Colors.grey[200],
      Colors.green[200],
      Colors.green[400],
      Colors.green[700],
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[activityLevel],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: activityLevel == 0 ? Colors.grey[600] : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTagItem(String tag, String count, Color color) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(tag),
      trailing: Text(
        count,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  // 태그 색상을 결정하는 메소드 추가
  Color _getTagColor(String tagName) {
    final Map<String, Color> tagColors = {
      '운동 및 스포츠': Colors.blue,
      '공부': Colors.green,
      '자기개발': Colors.orange,
      '취미': Colors.purple,
      '명상 및 스트레칭': Colors.red,
      '기타': Colors.grey,
    };
    
    return tagColors[tagName] ?? Colors.grey;
  }

  // ActivityData 리스트를 바 차트 데이터로 변환
  List<BarChartGroupData> _getBarData(List<ActivityData> activityData) {
    return List.generate(activityData.length, (index) {
      final data = activityData[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.completedQuests.toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  // 주간 활동 요약 카드 업데이트
  Widget _buildWeeklySummaryCard(List<ActivityData> weeklyData) {
    // 주간 총합 계산
    final totalCompletedQuests = weeklyData.fold<int>(
        0, (sum, data) => sum + data.completedQuests);
    final totalEarnedXp =
        weeklyData.fold<int>(0, (sum, data) => sum + data.earnedXp);
    final totalGoalAchievement =
        weeklyData.fold<int>(0, (sum, data) => sum + data.goalAchievement);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주간 활동 요약',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildWeeklySummaryItem(
              '완료한 퀘스트',
              '$totalCompletedQuests개',
              Icons.check_circle_outline,
              Colors.green,
            ),
            _buildWeeklySummaryItem(
              '획득한 경험치',
              '$totalEarnedXp XP',
              Icons.star_outline,
              Colors.amber,
            ),
            _buildWeeklySummaryItem(
              '달성한 목표',
              '$totalGoalAchievement',
              Icons.flag_outlined,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWeeklySummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getMockPieData() {
    return [
      PieChartSectionData(
        value: 30,
        color: Colors.blue,
        title: '30%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 25,
        color: Colors.green,
        title: '25%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.orange,
        title: '20%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 15,
        color: Colors.purple,
        title: '15%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 10,
        color: Colors.red,
        title: '10%',
        radius: 50,
      ),
    ];
  }

  List<BarChartGroupData> _getMockBarData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 10.0,
            color: Theme.of(context).colorScheme.primary,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}